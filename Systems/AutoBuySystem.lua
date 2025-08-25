-- AutoBuySystem.lua
-- Auto buy eggs functionality
local GameServices = require(script.Parent.Parent.Core.GameServices)
local GameConfig = require(script.Parent.Parent.Core.GameConfig)
local PlayerUtils = require(script.Parent.Parent.Core.PlayerUtils)
local StateManager = require(script.Parent.Parent.Core.StateManager)
local SettingsManager = require(script.Parent.Parent.Core.SettingsManager)
local RemoteService = require(script.Parent.Parent.Core.RemoteService)
local Constants = require(script.Parent.Parent.Core.Constants)

local AutoBuySystem = {}

-- Helper functions
local function getEggMutationFromGUI(eggUID)
    local islandName = PlayerUtils.getAssignedIslandName()
    if not islandName then
        return nil
    end

    local art = workspace:FindFirstChild("Art")
    if not art then
        return nil
    end

    local island = art:FindFirstChild(islandName)
    if not island then
        return nil
    end

    local env = island:FindFirstChild("ENV")
    if not env then
        return nil
    end

    local conveyor = env:FindFirstChild("Conveyor")
    if not conveyor then
        return nil
    end

    -- Check all conveyor belts
    for i = 1, 9 do
        local conveyorBelt = conveyor:FindFirstChild("Conveyor" .. i)
        if conveyorBelt then
            local belt = conveyorBelt:FindFirstChild("Belt")
            if belt then
                local eggModel = belt:FindFirstChild(eggUID)
                if eggModel and eggModel:IsA("Model") then
                    local rootPart = eggModel:FindFirstChild("RootPart")
                    if rootPart then
                        local eggGUI = rootPart:FindFirstChild("GUI/EggGUI")
                        if eggGUI then
                            local mutateText = eggGUI:FindFirstChild("Mutate")
                            if mutateText and mutateText:IsA("TextLabel") then
                                local mutationText = mutateText.Text
                                if mutationText and mutationText ~= "" then
                                    -- Map "Dino" to "Jurassic" for consistency
                                    if string.lower(mutationText) == "dino" then
                                        return "Jurassic"
                                    end
                                    return mutationText
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function shouldBuyEggInstance(eggInstance, playerMoney)
    if not eggInstance or not eggInstance:IsA("Model") then
        return false, nil, nil
    end

    -- Read Type first - check if this is the egg type we want
    local eggType = eggInstance:GetAttribute("Type") or eggInstance:GetAttribute("EggType") or
                        eggInstance:GetAttribute("Name")
    if not eggType then
        return false, nil, nil
    end
    eggType = tostring(eggType)

    -- If eggs are selected, check if this is the type we want
    local selectedTypeSet = StateManager.getSelection("selectedTypeSet")
    if selectedTypeSet and next(selectedTypeSet) then
        if not selectedTypeSet[eggType] then
            return false, nil, nil
        end
    end

    -- Now check mutation if mutations are selected
    local selectedMutationSet = StateManager.getSelection("selectedMutationSet")
    if selectedMutationSet and next(selectedMutationSet) then
        local eggMutation = getEggMutationFromGUI(eggInstance.Name)

        if not eggMutation then
            -- If mutations are selected but egg has no mutation, skip this egg
            return false, nil, nil
        end

        -- Check if egg has a selected mutation
        if not selectedMutationSet[eggMutation] then
            return false, nil, nil
        end
    end

    -- Get price from hardcoded data or instance attribute
    local price = nil
    if GameConfig.EggData[eggType] then
        -- Convert price string to number (remove commas and convert to number)
        local priceStr = GameConfig.EggData[eggType].Price:gsub(",", "")
        price = tonumber(priceStr)
    end

    if not price then
        price = eggInstance:GetAttribute("Price")
    end

    if type(price) ~= "number" then
        return false, nil, nil
    end
    if playerMoney < price then
        return false, nil, nil
    end

    return true, eggInstance.Name, price
end

local function getActiveBelt(islandName)
    if type(islandName) ~= "string" or islandName == "" then
        return nil
    end

    local art = workspace:FindFirstChild("Art")
    if not art then
        return nil
    end

    local island = art:FindFirstChild(islandName)
    if not island then
        return nil
    end

    local env = island:FindFirstChild("ENV")
    if not env then
        return nil
    end

    local conveyorRoot = env:FindFirstChild("Conveyor")
    if not conveyorRoot then
        return nil
    end

    local belts = {}
    -- Strictly look for Conveyor1..Conveyor9 in order
    for i = 1, 9 do
        local c = conveyorRoot:FindFirstChild("Conveyor" .. i)
        if c then
            local b = c:FindFirstChild("Belt")
            if b then
                table.insert(belts, b)
            end
        end
    end

    if #belts == 0 then
        return nil
    end

    local hrp = GameServices.LocalPlayer.Character and
                    GameServices.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hrpPos = hrp and hrp.Position or Vector3.new()
    local bestBelt, bestScore

    for _, belt in ipairs(belts) do
        local children = belt:GetChildren()
        local eggs = 0
        local samplePos

        for _, ch in ipairs(children) do
            if ch:IsA("Model") then
                eggs = eggs + 1
                if not samplePos then
                    local ok, cf = pcall(function()
                        return ch:GetPivot()
                    end)
                    if ok and cf then
                        samplePos = cf.Position
                    end
                end
            end
        end

        if not samplePos then
            local p = belt.Parent and belt.Parent:FindFirstChildWhichIsA("BasePart", true)
            samplePos = p and p.Position or hrpPos
        end

        local dist = (samplePos - hrpPos).Magnitude
        -- Higher eggs preferred; for tie, closer belt preferred
        local score = eggs * 100000 - dist
        if not bestScore or score > bestScore then
            bestScore, bestBelt = score, belt
        end
    end

    return bestBelt
end

local function buyEggInstantly(eggInstance)
    local placement = StateManager.getPlacementState()
    if placement.buyingInProgress then
        return
    end

    StateManager.setPlacingInProgress(true)

    local netWorth = PlayerUtils.getPlayerNetWorth()
    local ok, uid, price = shouldBuyEggInstance(eggInstance, netWorth)

    if ok then
        -- Retry mechanism - try up to 3 times with delays
        local maxRetries = 3
        local retryCount = 0
        local buySuccess = false

        while retryCount < maxRetries and not buySuccess do
            retryCount = retryCount + 1

            -- Check if egg still exists and is still valid
            if not eggInstance or not eggInstance.Parent then
                break
            end

            -- Check if we still want to buy it (price might have changed)
            local stillOk, stillUid, stillPrice = shouldBuyEggInstance(eggInstance, PlayerUtils.getPlayerNetWorth())
            if not stillOk then
                break
            end

            -- Try to buy
            local buyResult = RemoteService.buyEgg(uid) and RemoteService.focusEgg(uid)

            if buyResult then
                buySuccess = true
            else
                task.wait(0.5) -- Wait 0.5 seconds before retry
            end
        end
    end

    StateManager.setPlacingInProgress(false)
end

local function setupBeltMonitoring(belt)
    if not belt then
        return
    end

    local placement = StateManager.getPlacementState()

    -- Monitor for new eggs appearing
    local function onChildAdded(child)
        if not StateManager.isAutomationEnabled("autoBuyEnabled") then
            return
        end
        if child:IsA("Model") then
            task.wait(0.1) -- Small delay to ensure attributes are set
            buyEggInstantly(child)
        end
    end

    -- Monitor existing eggs for price/money changes
    local function checkExistingEggs()
        if not StateManager.isAutomationEnabled("autoBuyEnabled") then
            return
        end
        local children = belt:GetChildren()
        for _, child in ipairs(children) do
            if child:IsA("Model") then
                buyEggInstantly(child)
            end
        end
    end

    -- Connect events
    table.insert(placement.beltConnections, belt.ChildAdded:Connect(onChildAdded))

    -- Check existing eggs periodically
    local checkThread = task.spawn(function()
        while StateManager.isAutomationEnabled("autoBuyEnabled") do
            checkExistingEggs()
            task.wait(0.5) -- Check every 0.5 seconds
        end
    end)

    -- Store thread for cleanup
    table.insert(placement.beltConnections, {
        disconnect = function()
            if checkThread then
                task.cancel(checkThread)
                checkThread = nil
            end
        end
    })
end

local function cleanupBeltConnections()
    local placement = StateManager.getPlacementState()
    for _, conn in ipairs(placement.beltConnections) do
        pcall(function()
            if conn.disconnect then
                conn.disconnect()
            else
                conn:Disconnect()
            end
        end)
    end
    placement.beltConnections = {}
end

-- Main auto buy function
function AutoBuySystem.runAutoBuy()
    while StateManager.isAutomationEnabled("autoBuyEnabled") do
        local islandName = PlayerUtils.getAssignedIslandName()

        if not islandName or islandName == "" then
            task.wait(1)
            goto continue
        end

        local activeBelt = getActiveBelt(islandName)
        if not activeBelt then
            task.wait(1)
            goto continue
        end

        -- Setup monitoring for this belt
        cleanupBeltConnections()
        setupBeltMonitoring(activeBelt)

        -- Wait until disabled or island changes
        while StateManager.isAutomationEnabled("autoBuyEnabled") do
            local currentIsland = PlayerUtils.getAssignedIslandName()
            if currentIsland ~= islandName then
                break -- Island changed, restart monitoring
            end
            task.wait(0.5)
        end

        ::continue::
    end

    cleanupBeltConnections()
end

function AutoBuySystem.cleanup()
    cleanupBeltConnections()
end

return AutoBuySystem
