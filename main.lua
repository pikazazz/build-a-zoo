local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local vector = {
    create = function(x, y, z)
        return Vector3.new(x, y, z)
    end
}
local LocalPlayer = Players.LocalPlayer

-- state variables
local settingsLoaded = false
local function waitForSettingsReady(extraDelay)
    while not settingsLoaded do
        task.wait(0.1)
    end
    if extraDelay then
        task.wait(extraDelay)
    end
end
local beltConnection = {}
local lastBeltChildren = {}
local buyingInProgress = false
local selectedTypeSet = {}
local selectedMutationSet = {}

-- Create the main window
local Window = Fluent:CreateWindow({
    Title = "Build A Zoo",
    SubTitle = "by m0rgause",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    -- Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-- Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Money = Window:AddTab({
        Title = "Money",
        Icon = ""
    }),
    Eggs = Window:AddTab({
        Title = "Eggs",
        Icon = ""
    }),
    Settings = Window:AddTab({
        Title = "Settings",
        Icon = ""
    })
}

-- helper
local Options = Fluent.Options
local function getAssignedIslandName()
    if not LocalPlayer then
        return nil
    end
    return LocalPlayer:GetAttribute("AssignedIslandName") or nil
end
local function getIslandBelts(islandName)
    if type(islandName) ~= "string" or islandName == "" then
        return {}
    end
    local art = workspace:FindFirstChild("Art")
    if not art then
        return {}
    end
    local island = art:FindFirstChild(islandName)
    if not island then
        return {}
    end
    local env = island.FindFirstChild("ENV")
    if not env then return {} end 
    local belts = {}
    for i = 1,9 do
        local c = conveyorRoot:FindFirstChild("Conveyor" .. i)
        if c then
            local b = c:FindFirstChild("Belt")
            if b then
                table.insert(belts, b)
            end
        end
    end
    return belts
end

local function getActiveBelt(islandName)
    local belts = getIslandBelts(islandName)
    if #belts == 0 then return nil end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hrpPos = hrp and hrp.Position or Vector3.new()
    local bestBelt, bestScore, bestDist
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
        local score = eggs * 100000 - dist
        if not bestScore or score > bestScore then
            bestScore, bestDist, bestBelt = score, dist, belt
        end
    end
    return bestBelt
end



local function cleanupBeltConnection()
   for _, conn in ipairs(beltConnection) do
        pcall(function() conn:Disconnect() end)
    end
    beltConnection = {}
end

local function setupBeltMonitoring(belt)
    if not belt then return end

    local function onChildAdded(child)
        if not autoBuyEnabled then return end
        if child:IsA("Model") then
            task.wait(0.2) -- let the egg settle
            buyEggFromBelt(child)
        end
    end
end

local function getPlayerNetWorth()
    local player = Players.LocalPlayer
    if not player then return 0 end

    local attrValue = player:GetAttribute("NetWorth")
    if type(attrValue) == "number" then
        return attrValue
    end

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return 0 end
    local netWorthStat = leaderstats:FindFirstChild("NetWorth")
    if not netWorthStat then return 0 end
    return netWorthStat.Value or 0
end

local function getEggMutationFromGUI(eggUID)
    local islandName = getAssignedIslandName()
    if not islandName then return nil end
    
    local art = workspace:FindFirstChild("Art")
    if not art then return nil end

    local island = art:FindFirstChild(islandName)
    if not island then return nil end

    local env = island:FindFirstChild("ENV")
    if not env then return nil end

    local conveyor = env:FindFirstChild("Conveyor")
    if not conveyor then return nil end

    for i = 1,9 do
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
end

local function shouldBuyEggInstance(eggInstance)
    if not eggInstance or not eggInstance:IsA("Model") then
        return false, nil, nil
    end

    -- Read Type first - check if this is the egg type we want
    local eggType = eggInstance:GetAttribute("Type") 
        or eggInstance:GetAttribute("EggType") 
        or eggInstance:GetAttribute("Name")
    if not eggType then return false, nil, nil end
    eggType = tostring(eggType)

    -- if eggs are selected, check if this is the type we want
    if selectedTypeSet and next(selectedTypeSet) then
        if not selectedTypeSet[eggType] then
            return false, nil, nil
        end
    end

    -- Now check mutation if mutations are selected
    if selectedMutationSet and next(selectedMutationSet) then
        -- local eggMutation = 
    end

end

local function buyEggFromBelt(eggInstance)
    if buyingInProgress then return end
    buyingInProgress = true

    local netWorth = getPlayerNetWorth()
    local ok, uid, price = shouldBuyEggInstance(eggInstance, netWorth)
end


do
    -- ============= Money Tab =============
    local moneyClaimEnabled = false
    local moneyClaimThread = nil
    local moneyClaimDelay = 60

    local function getOwnedPetNames()
        local petNames = {}
        local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
        local data = playerGui and playerGui:FindFirstChild("Data")
        local petsContainer = data and data:FindFirstChild("Pets")
        if petsContainer then
            for _, child in ipairs(petsContainer:GetChildren()) do
                -- Assume children under Data.Pets are ValueBase instances or folders named as pet names
                local n
                if child:IsA("ValueBase") then
                    n = tostring(child.Value)
                else
                    n = tostring(child.Name)
                end
                if n and n ~= "" then
                    table.insert(petNames, n)
                end
            end
        end
        return petNames
    end

    local function claimMoneyForPet(petName)
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
        local ok, err = pcall(function()
            re:FireServer("Claim")
        end)
        if not ok then
            warn("Claim failed for pet " .. tostring(petName) .. ": " .. tostring(err))
        end
        return ok
    end

    local function runMoneyClaimLoop()
        while moneyClaimEnabled do
            task.wait(1) -- Prevents tight loop if something goes wrong
            if not moneyClaimEnabled then
                break
            end
            -- Use pcall to catch any unexpected errors and continue the loop
            local ok, err = pcall(function()
                local petNames = getOwnedPetNames()
                if #petNames == 0 then
                    task.wait(5)
                    return
                end
                for _, petName in ipairs(petNames) do
                    claimMoneyForPet(petName)
                    task.wait(0.05)
                end
                task.wait(moneyClaimDelay)
            end)
            if not ok then
                warn("Money claim loop error: " .. tostring(err))
            end
        end
    end

    Tabs.Money:AddButton({
        Title = "Claim Money",
        Description = "Claim money for your pets",
        Callback = function()
            local petNames = getOwnedPetNames()
            if #petNames == 0 then
                Fluent:Notify({
                    Title = "No Pets",
                    Content = "You don't own any pets to claim money for.",
                    Duration = 5
                })
                return
            end
            local claimedCount = 0
            for _, petName in ipairs(petNames) do
                if claimMoneyForPet(petName) then
                    claimedCount = claimedCount + 1
                end
                task.wait(0.05)
            end
            Fluent:Notify({
                Title = "Claim Complete",
                Content = "Claimed money for " .. tostring(claimedCount) .. " pets.",
                Duration = 5
            })
        end
    })

    local moneyToggle = Tabs.Money:AddToggle("MoneyClaimToggle", {
        Title = "Auto Claim Money",
        Description = "Automatically claim money for your pets with customization",
        Default = false
    })

    moneyToggle:OnChanged(function()
        moneyClaimEnabled = moneyToggle.Value

        if moneyClaimEnabled then
            -- print("Starting auto  DPR LOOP")
            if not autoClaimThread then
                autoClaimThread = task.spawn(function()
                    runMoneyClaimLoop()
                    autoClaimThread = nil
                end)
            end
        else
            if autoClaimThread then
                autoClaimThread = nil -- This will stop the loop on next iteration
            end
        end
    end)

    local moneyClaimDelaySlider = Tabs.Money:AddSlider("MoneyClaimDelay", {
        Title = "Claim Delay (seconds)",
        Description = "Set delay between each pet claim",
        Min = 60,
        Max = 300,
        Default = moneyClaimDelay,
        Rounding = 0,
        Callback = function(Value)
            moneyClaimDelay = Value
        end
    })

    -- ============= Egg Tab =============
    local eggConfig = {}
    local mutationConfig = {}
    local eggBuyEnabled = false
    local eggBuyThread = nil

    local function runEggBuyLoop()
        while eggBuyEnabled do
            local islandName = getAssignedIslandName()
            if not islandName or islandName == "" then
                task.wait(1)
                continue -- skip to next iteration
            end

            local activeBelt = getActiveBelt(islandName)
            if not activeBelt then
                task.wait(1)
                continue -- skip to next iteration
            end

            cleanupBeltConnection()
            setupBeltMonitoring(activeBelt)


        end
    end

    local autoBuyToggle = Tabs.Eggs:AddToggle("AutoBuyEggsToggle", {
        Title = "Auto Buy Eggs",
        Description = "Automatically buy eggs with customization",
        Default = false
    })

    autoBuyToggle:OnChanged(function()
        eggBuyEnabled = autoBuyToggle.Value

        waitForSettingsReady(0.2)
        if eggBuyEnabled and not eggBuyThread then
            eggBuyThread = task.spawn(function()
                runEggBuyLoop()
                eggBuyThread = nil
            end)
        elseif (not eggBuyEnabled) and eggBuyThread then
            cleanupBeltConnection()
        end
    end)

    -- Tabs.Main:AddParagraph({
    --     Title = "Paragraph",
    --     Content = "This is a paragraph.\nSecond line!"
    -- })

    -- Tabs.Main:AddButton({
    --     Title = "Button",
    --     Description = "Very important button",
    --     Callback = function()
    --         Window:Dialog({
    --             Title = "Title",
    --             Content = "This is a dialog",
    --             Buttons = {{
    --                 Title = "Confirm",
    --                 Callback = function()
    --                     print("Confirmed the dialog.")
    --                 end
    --             }, {
    --                 Title = "Cancel",
    --                 Callback = function()
    --                     print("Cancelled the dialog.")
    --                 end
    --             }}
    --         })
    --     end
    -- })

    -- local Toggle = Tabs.Main:AddToggle("MyToggle", {
    --     Title = "Toggle",
    --     Default = false
    -- })

    -- Toggle:OnChanged(function()
    --     print("Toggle changed:", Options.MyToggle.Value)
    -- end)

    -- Options.MyToggle:SetValue(false)

    -- local Slider = Tabs.Main:AddSlider("Slider", {
    --     Title = "Slider",
    --     Description = "This is a slider",
    --     Default = 2,
    --     Min = 0,
    --     Max = 5,
    --     Rounding = 1,
    --     Callback = function(Value)
    --         print("Slider was changed:", Value)
    --     end
    -- })

    -- Slider:OnChanged(function(Value)
    --     print("Slider changed:", Value)
    -- end)

    -- Slider:SetValue(3)

    -- local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    --     Title = "Dropdown",
    --     Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve",
    --               "thirteen", "fourteen"},
    --     Multi = false,
    --     Default = 1
    -- })

    -- Dropdown:SetValue("four")

    -- Dropdown:OnChanged(function(Value)
    --     print("Dropdown changed:", Value)
    -- end)

    -- local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
    --     Title = "Dropdown",
    --     Description = "You can select multiple values.",
    --     Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve",
    --               "thirteen", "fourteen"},
    --     Multi = true,
    --     Default = {"seven", "twelve"}
    -- })

    -- MultiDropdown:SetValue({
    --     three = true,
    --     five = true,
    --     seven = false
    -- })

    -- MultiDropdown:OnChanged(function(Value)
    --     local Values = {}
    --     for Value, State in next, Value do
    --         table.insert(Values, Value)
    --     end
    --     print("Mutlidropdown changed:", table.concat(Values, ", "))
    -- end)

    -- local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
    --     Title = "Colorpicker",
    --     Default = Color3.fromRGB(96, 205, 255)
    -- })

    -- Colorpicker:OnChanged(function()
    --     print("Colorpicker changed:", Colorpicker.Value)
    -- end)

    -- Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

    -- local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
    --     Title = "Colorpicker",
    --     Description = "but you can change the transparency.",
    --     Transparency = 0,
    --     Default = Color3.fromRGB(96, 205, 255)
    -- })

    -- TColorpicker:OnChanged(function()
    --     print("TColorpicker changed:", TColorpicker.Value, "Transparency:", TColorpicker.Transparency)
    -- end)

    -- local Keybind = Tabs.Main:AddKeybind("Keybind", {
    --     Title = "KeyBind",
    --     Mode = "Toggle", -- Always, Toggle, Hold
    --     Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    --     -- Occurs when the keybind is clicked, Value is `true`/`false`
    --     Callback = function(Value)
    --         print("Keybind clicked!", Value)
    --     end,

    --     -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    --     ChangedCallback = function(New)
    --         print("Keybind changed!", New)
    --     end
    -- })

    -- -- OnClick is only fired when you press the keybind and the mode is Toggle
    -- -- Otherwise, you will have to use Keybind:GetState()
    -- Keybind:OnClick(function()
    --     print("Keybind clicked:", Keybind:GetState())
    -- end)

    -- Keybind:OnChanged(function()
    --     print("Keybind changed:", Keybind.Value)
    -- end)

    -- task.spawn(function()
    --     while true do
    --         wait(1)

    --         -- example for checking if a keybind is being pressed
    --         local state = Keybind:GetState()
    --         if state then
    --             print("Keybind is being held down")
    --         end

    --         if Fluent.Unloaded then
    --             break
    --         end
    --     end
    -- end)

    -- Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold

    -- local Input = Tabs.Main:AddInput("Input", {
    --     Title = "Input",
    --     Default = "Default",
    --     Placeholder = "Placeholder",
    --     Numeric = false, -- Only allows numbers
    --     Finished = false, -- Only calls callback when you press enter
    --     Callback = function(Value)
    --         print("Input changed:", Value)
    --     end
    -- })

    -- Input:OnChanged(function()
    --     print("Input updated:", Input.Value)
    -- end)
end

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
