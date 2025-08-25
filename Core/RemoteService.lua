-- RemoteService.lua
-- Handles all remote function calls to the game
local GameServices = require(script.Parent.GameServices)
local ReplicatedStorage = GameServices.ReplicatedStorage
local VirtualInputManager = GameServices.VirtualInputManager

local RemoteService = {}

-- Character remote calls
function RemoteService.buyEgg(eggUID)
    local args = {"BuyEgg", eggUID}
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
    end)

    if not success then
        warn("Failed to fire BuyEgg for UID " .. tostring(eggUID) .. ": " .. tostring(err))
    end

    return success
end

function RemoteService.focusEgg(eggUID)
    local args = {"Focus", eggUID}
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
    end)

    if not success then
        warn("Failed to fire Focus for UID " .. tostring(eggUID) .. ": " .. tostring(err))
    end

    return success
end

function RemoteService.placePet(position, petUID)
    local args = {"Place", {
        DST = GameServices.vector.create(position.X, position.Y, position.Z),
        ID = petUID
    }}

    local success, err = pcall(function()
        local remote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("CharacterRE")
        if remote then
            remote:FireServer(unpack(args))
        else
            error("CharacterRE remote not found")
        end
    end)

    if not success then
        warn("Failed to fire Place for PET UID " .. tostring(petUID) .. " at " .. tostring(position) .. ": " ..
                 tostring(err))
    end

    return success
end

function RemoteService.deletePet(petName)
    local args = {"Del", petName}
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
    end)

    if not success then
        warn("Failed to delete pet " .. tostring(petName) .. ": " .. tostring(err))
    end

    return success
end

function RemoteService.unlockTile(farmPart)
    local args = {"Unlock", farmPart}
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
    end)

    if not success then
        warn("Failed to unlock tile: " .. tostring(err))
    end

    return success
end

-- Conveyor remote calls
function RemoteService.upgradeConveyor(index)
    local args = {"Upgrade", tonumber(index) or index}
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Remote"):WaitForChild("ConveyorRE"):FireServer(table.unpack(args))
    end)

    if not success then
        warn("Conveyor Upgrade fire failed: " .. tostring(err))
    end

    return success
end

-- Dino event remote calls
function RemoteService.claimDino()
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Remote"):WaitForChild("DinoEventRE"):FireServer({
            event = "onlinepack"
        })
    end)

    if not success then
        warn("DinoClaim fire failed: " .. tostring(err))
    end

    return success
end

-- Fruit store remote calls
function RemoteService.buyFruit(fruitId)
    local args = {fruitId}
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Remote"):WaitForChild("FoodStoreRE"):FireServer(unpack(args))
    end)

    if not success then
        warn("Failed to buy fruit " .. tostring(fruitId) .. ": " .. tostring(err))
    end

    return success
end

-- Pet claiming remote calls
function RemoteService.claimPetMoney(petName)
    if not petName or petName == "" then
        return false
    end

    local petsFolder = workspace:FindFirstChild("Pets")
    if not petsFolder then
        return false
    end

    local petModel = petsFolder:FindFirstChild(petName)
    if not petModel then
        return false
    end

    local root = petModel:FindFirstChild("RootPart")
    if not root then
        return false
    end

    local re = root:FindFirstChild("RE")
    if not re or not re.FireServer then
        return false
    end

    local success, err = pcall(function()
        re:FireServer("Claim")
    end)

    if not success then
        warn("Claim failed for pet " .. tostring(petName) .. ": " .. tostring(err))
    end

    return success
end

-- Virtual input helpers
function RemoteService.pressKey(keyCode, holdDuration)
    holdDuration = holdDuration or 0

    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    if holdDuration > 0 then
        task.wait(holdDuration)
    end
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)

    return true
end

function RemoteService.pressProximityPrompt(prompt)
    if typeof(prompt) ~= "Instance" or not prompt:IsA("ProximityPrompt") then
        return false
    end

    -- Try executor helper first
    if _G and typeof(_G.fireproximityprompt) == "function" then
        local success = pcall(function()
            _G.fireproximityprompt(prompt, prompt.HoldDuration or 0)
        end)
        if success then
            return true
        end
    end

    -- Pure client fallback: simulate the prompt key with VirtualInput
    local key = prompt.KeyboardKeyCode
    if key == Enum.KeyCode.Unknown or key == nil then
        key = Enum.KeyCode.E
    end

    -- LoS and distance flexibility
    pcall(function()
        prompt.RequiresLineOfSight = false
        prompt.Enabled = true
    end)

    local hold = prompt.HoldDuration or 0
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    if hold > 0 then
        task.wait(hold + 0.05)
    end
    VirtualInputManager:SendKeyEvent(false, key, false, game)

    return true
end

return RemoteService
