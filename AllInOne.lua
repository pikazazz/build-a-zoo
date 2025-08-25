-- AllInOne.lua
-- Single-file version with clean modular structure for HTTP execution
-- Execute with: loadstring(game:HttpGet("https://raw.githubusercontent.com/m0rgause/build-a-zoo/refs/heads/main/AllInOne.lua"))()
-- ============================================================================
-- CORE MODULES (Self-contained)
-- ============================================================================
-- GameServices Module
local GameServices = {}
do
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CollectionService = game:GetService("CollectionService")
    local ProximityPromptService = game:GetService("ProximityPromptService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")

    GameServices.Players = Players
    GameServices.ReplicatedStorage = ReplicatedStorage
    GameServices.CollectionService = CollectionService
    GameServices.ProximityPromptService = ProximityPromptService
    GameServices.VirtualInputManager = VirtualInputManager
    GameServices.TeleportService = TeleportService
    GameServices.HttpService = HttpService
    GameServices.LocalPlayer = Players.LocalPlayer

    GameServices.vector = {
        create = function(x, y, z)
            return Vector3.new(x, y, z)
        end
    }
end

-- Constants Module
local Constants = {}
do
    Constants.UI = {
        WINDOW_TITLE = "Build A Zoo",
        WINDOW_ICON = "app-window-mac",
        WINDOW_SIZE = UDim2.fromOffset(520, 360),
        AUTHOR = "Zebux",
        FOLDER = "Zebux",
        THEME = "Dark"
    }

    Constants.FILES = {
        EGG_SELECTIONS = "Zebux_EggSelections.json",
        FRUIT_SELECTIONS = "Zebux_FruitSelections.json",
        FEED_FRUIT_SELECTIONS = "Zebux_FeedFruitSelections.json",
        AUTO_PLACE_SELECTIONS = "Zebux_AutoPlaceSelections.json",
        CUSTOM_SELECTIONS = "Zebux_CustomSelections.json"
    }

    Constants.DELAYS = {
        AUTO_CLAIM_DEFAULT = 0.1,
        AUTO_PLACE_BETWEEN_ATTEMPTS = 0.2,
        AUTO_HATCH_BETWEEN_EGGS = 0.2,
        AUTO_BUY_CHECK_INTERVAL = 0.5,
        SETTINGS_LOAD_WAIT = 3.0
    }

    Constants.PLACEMENT = {
        EGG_HEIGHT_OFFSET = 12,
        TILE_SIZE = 8,
        OCCUPANCY_CHECK_RADIUS_XZ = 4.0,
        OCCUPANCY_CHECK_RADIUS_Y = 8.0,
        MIN_DISTANCE_DEFAULT = 6
    }

    Constants.URLS = {
        WINDUI = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
        EGG_SELECTION = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/EggSelection.lua",
        FRUIT_SELECTION = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/FruitSelection.lua",
        FEED_FRUIT_SELECTION = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/FeedFruitSelection.lua",
        AUTO_FEED_SYSTEM = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/AutoFeedSystem.lua",
        AUTO_QUEST_SYSTEM = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/AutoQuestSystem.lua"
    }

    Constants.TABS = {
        AUTO_BUY = {
            title = "🥚 | Buy Eggs",
            icon = "shopping-cart"
        },
        AUTO_PLACE = {
            title = "🏠 | Place Pets",
            icon = "home"
        },
        AUTO_HATCH = {
            title = "⚡ | Hatch Eggs",
            icon = "zap"
        },
        AUTO_CLAIM = {
            title = "💰 | Get Money",
            icon = "dollar-sign"
        },
        SHOP = {
            title = "🛒 | Shop",
            icon = "shopping-bag"
        },
        PACKS = {
            title = "🎁 | Get Packs",
            icon = "gift"
        },
        FRUIT = {
            title = "🍎 | Fruit Store",
            icon = "apple"
        },
        FEED = {
            title = "🍽️ | Auto Feed",
            icon = "utensils"
        },
        SAVE = {
            title = "💾 | Save Settings",
            icon = "save"
        }
    }
end

-- GameConfig Module
local GameConfig = {}
do
    local configs = {
        eggConfig = {},
        conveyorConfig = {},
        petFoodConfig = {},
        mutationConfig = {}
    }

    GameConfig.EggData = {
        BasicEgg = {
            Name = "Basic Egg",
            Price = "100",
            Icon = "rbxassetid://129248801621928",
            Rarity = 1
        },
        RareEgg = {
            Name = "Rare Egg",
            Price = "500",
            Icon = "rbxassetid://71012831091414",
            Rarity = 2
        },
        SuperRareEgg = {
            Name = "Super Rare Egg",
            Price = "2,500",
            Icon = "rbxassetid://93845452154351",
            Rarity = 2
        },
        EpicEgg = {
            Name = "Epic Egg",
            Price = "15,000",
            Icon = "rbxassetid://116395645531721",
            Rarity = 2
        },
        LegendEgg = {
            Name = "Legend Egg",
            Price = "100,000",
            Icon = "rbxassetid://90834918351014",
            Rarity = 3
        },
        PrismaticEgg = {
            Name = "Prismatic Egg",
            Price = "1,000,000",
            Icon = "rbxassetid://79960683434582",
            Rarity = 4
        },
        HyperEgg = {
            Name = "Hyper Egg",
            Price = "2,500,000",
            Icon = "rbxassetid://104958288296273",
            Rarity = 4
        },
        VoidEgg = {
            Name = "Void Egg",
            Price = "24,000,000",
            Icon = "rbxassetid://122396162708984",
            Rarity = 5
        },
        BowserEgg = {
            Name = "Bowser Egg",
            Price = "130,000,000",
            Icon = "rbxassetid://71500536051510",
            Rarity = 5
        },
        DemonEgg = {
            Name = "Demon Egg",
            Price = "400,000,000",
            Icon = "rbxassetid://126412407639969",
            Rarity = 5
        },
        CornEgg = {
            Name = "Corn Egg",
            Price = "1,000,000,000",
            Icon = "rbxassetid://94739512852461",
            Rarity = 5
        },
        BoneDragonEgg = {
            Name = "Bone Dragon Egg",
            Price = "2,000,000,000",
            Icon = "rbxassetid://83209913424562",
            Rarity = 5
        },
        UltraEgg = {
            Name = "Ultra Egg",
            Price = "10,000,000,000",
            Icon = "rbxassetid://83909590718799",
            Rarity = 6
        },
        DinoEgg = {
            Name = "Dino Egg",
            Price = "10,000,000,000",
            Icon = "rbxassetid://80783528632315",
            Rarity = 6
        },
        FlyEgg = {
            Name = "Fly Egg",
            Price = "999,999,999,999",
            Icon = "rbxassetid://109240587278187",
            Rarity = 6
        },
        UnicornEgg = {
            Name = "Unicorn Egg",
            Price = "40,000,000,000",
            Icon = "rbxassetid://123427249205445",
            Rarity = 6
        },
        AncientEgg = {
            Name = "Ancient Egg",
            Price = "999,999,999,999",
            Icon = "rbxassetid://113910587565739",
            Rarity = 6
        }
    }

    GameConfig.MutationData = {
        Golden = {
            Name = "Golden",
            Icon = "✨",
            Rarity = 10
        },
        Diamond = {
            Name = "Diamond",
            Icon = "💎",
            Rarity = 20
        },
        Electric = {
            Name = "Electric",
            Icon = "⚡",
            Rarity = 50
        },
        Fire = {
            Name = "Fire",
            Icon = "🔥",
            Rarity = 100
        },
        Jurassic = {
            Name = "Jurassic",
            Icon = "🦕",
            Rarity = 100
        }
    }

    function GameConfig.loadEggConfig()
        local success, cfg = pcall(function()
            local cfgFolder = GameServices.ReplicatedStorage:WaitForChild("Config")
            local module = cfgFolder:WaitForChild("ResEgg")
            return require(module)
        end)
        if success and type(cfg) == "table" then
            configs.eggConfig = cfg
        else
            configs.eggConfig = {}
        end
        return configs.eggConfig
    end

    function GameConfig.getEggConfig()
        return configs.eggConfig
    end

    function GameConfig.initializeAll()
        GameConfig.loadEggConfig()
    end
end

-- StateManager Module
local StateManager = {}
do
    local state = {
        ui = {
            eggSelectionVisible = false,
            fruitSelectionVisible = false,
            feedFruitSelectionVisible = false,
            settingsLoaded = false
        },
        automation = {
            autoBuyEnabled = false,
            autoPlaceEnabled = false,
            autoHatchEnabled = false,
            autoClaimEnabled = false,
            autoFeedEnabled = false
        },
        selections = {
            selectedTypeSet = {},
            selectedMutationSet = {},
            selectedFruits = {},
            selectedFeedFruits = {}
        },
        threads = {
            autoBuyThread = nil
        },
        placement = {
            buyingInProgress = false,
            beltConnections = {}
        }
    }

    function StateManager.isAutomationEnabled(automationType)
        return state.automation[automationType] or false
    end

    function StateManager.setAutomationEnabled(automationType, enabled)
        state.automation[automationType] = enabled
    end

    function StateManager.getThread(threadName)
        return state.threads[threadName]
    end

    function StateManager.setThread(threadName, thread)
        state.threads[threadName] = thread
    end

    function StateManager.getSelection(selectionType)
        return state.selections[selectionType] or {}
    end

    function StateManager.setSelection(selectionType, selection)
        state.selections[selectionType] = selection
    end

    function StateManager.isUIVisible(uiType)
        return state.ui[uiType] or false
    end

    function StateManager.setUIVisible(uiType, visible)
        state.ui[uiType] = visible
    end

    function StateManager.areSettingsLoaded()
        return state.ui.settingsLoaded
    end

    function StateManager.setSettingsLoaded(loaded)
        state.ui.settingsLoaded = loaded
    end

    function StateManager.getPlacementState()
        return state.placement
    end

    function StateManager.setPlacingInProgress(inProgress)
        state.placement.buyingInProgress = inProgress
    end
end

-- PlayerUtils Module
local PlayerUtils = {}
do
    function PlayerUtils.getAssignedIslandName()
        if not GameServices.LocalPlayer then
            return nil
        end
        return GameServices.LocalPlayer:GetAttribute("AssignedIslandName")
    end

    function PlayerUtils.getPlayerNetWorth()
        if not GameServices.LocalPlayer then
            return 0
        end

        local attrValue = GameServices.LocalPlayer:GetAttribute("NetWorth")
        if type(attrValue) == "number" then
            return attrValue
        end

        local leaderstats = GameServices.LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local netWorthValue = leaderstats:FindFirstChild("NetWorth")
            if netWorthValue and type(netWorthValue.Value) == "number" then
                return netWorthValue.Value
            end
        end

        return 0
    end

    function PlayerUtils.getPlayerRootPosition()
        local character = GameServices.LocalPlayer and GameServices.LocalPlayer.Character
        if not character then
            return nil
        end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return nil
        end
        return hrp.Position
    end
end

-- RemoteService Module
local RemoteService = {}
do
    function RemoteService.buyEgg(eggUID)
        local args = {"BuyEgg", eggUID}
        local success, err = pcall(function()
            GameServices.ReplicatedStorage:WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
        end)

        if not success then
            warn("Failed to fire BuyEgg for UID " .. tostring(eggUID) .. ": " .. tostring(err))
        end

        return success
    end

    function RemoteService.focusEgg(eggUID)
        local args = {"Focus", eggUID}
        local success, err = pcall(function()
            GameServices.ReplicatedStorage:WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
        end)

        if not success then
            warn("Failed to fire Focus for UID " .. tostring(eggUID) .. ": " .. tostring(err))
        end

        return success
    end
end

-- SettingsManager Module
local SettingsManager = {}
do
    function SettingsManager.loadAllSettings()
        -- Placeholder for settings loading
    end

    function SettingsManager.saveAllSettings()
        -- Placeholder for settings saving
    end

    function SettingsManager.updateCustomUISelection(uiType, selections)
        if uiType == "eggSelections" then
            StateManager.setSelection("selectedTypeSet", selections.eggs or {})
            StateManager.setSelection("selectedMutationSet", selections.mutations or {})
        end
    end

    function SettingsManager.waitForSettingsReady(extraDelay)
        while not StateManager.areSettingsLoaded() do
            task.wait(0.1)
        end
        if extraDelay and extraDelay > 0 then
            task.wait(extraDelay)
        end
    end
end

-- ============================================================================
-- SYSTEM MODULES
-- ============================================================================

-- AutoBuySystem Module
local AutoBuySystem = {}
do
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

        local eggType = eggInstance:GetAttribute("Type") or eggInstance:GetAttribute("EggType") or
                            eggInstance:GetAttribute("Name")
        if not eggType then
            return false, nil, nil
        end
        eggType = tostring(eggType)

        local selectedTypeSet = StateManager.getSelection("selectedTypeSet")
        if selectedTypeSet and next(selectedTypeSet) then
            if not selectedTypeSet[eggType] then
                return false, nil, nil
            end
        end

        local selectedMutationSet = StateManager.getSelection("selectedMutationSet")
        if selectedMutationSet and next(selectedMutationSet) then
            local eggMutation = getEggMutationFromGUI(eggInstance.Name)

            if not eggMutation then
                return false, nil, nil
            end

            if not selectedMutationSet[eggMutation] then
                return false, nil, nil
            end
        end

        local price = nil
        if GameConfig.EggData[eggType] then
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
            local maxRetries = 3
            local retryCount = 0
            local buySuccess = false

            while retryCount < maxRetries and not buySuccess do
                retryCount = retryCount + 1

                if not eggInstance or not eggInstance.Parent then
                    break
                end

                local stillOk, stillUid, stillPrice = shouldBuyEggInstance(eggInstance, PlayerUtils.getPlayerNetWorth())
                if not stillOk then
                    break
                end

                local buyResult = RemoteService.buyEgg(uid) and RemoteService.focusEgg(uid)

                if buyResult then
                    buySuccess = true
                else
                    task.wait(0.5)
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

        local function onChildAdded(child)
            if not StateManager.isAutomationEnabled("autoBuyEnabled") then
                return
            end
            if child:IsA("Model") then
                task.wait(0.1)
                buyEggInstantly(child)
            end
        end

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

        table.insert(placement.beltConnections, belt.ChildAdded:Connect(onChildAdded))

        local checkThread = task.spawn(function()
            while StateManager.isAutomationEnabled("autoBuyEnabled") do
                checkExistingEggs()
                task.wait(0.5)
            end
        end)

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

            cleanupBeltConnections()
            setupBeltMonitoring(activeBelt)

            while StateManager.isAutomationEnabled("autoBuyEnabled") do
                local currentIsland = PlayerUtils.getAssignedIslandName()
                if currentIsland ~= islandName then
                    break
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
end

-- ============================================================================
-- UI MANAGER
-- ============================================================================

local UIManager = {}
do
    local WindUI = nil
    local Window = nil
    local Config = nil
    local Tabs = {}

    function UIManager.initialize()
        WindUI = loadstring(game:HttpGet(Constants.URLS.WINDUI))()

        Window = WindUI:CreateWindow({
            Title = Constants.UI.WINDOW_TITLE,
            Icon = Constants.UI.WINDOW_ICON,
            IconThemed = true,
            Author = Constants.UI.AUTHOR,
            Folder = Constants.UI.FOLDER,
            Size = Constants.UI.WINDOW_SIZE,
            Transparent = true,
            Theme = Constants.UI.THEME
        })

        local ConfigManager = Window.ConfigManager
        Config = ConfigManager:CreateConfig("zebuxConfig")

        local MainSection = Window:Section({
            Title = "🤖 Auto Helpers",
            Opened = true
        })

        Tabs.AutoTab = MainSection:Tab({
            Title = Constants.TABS.AUTO_BUY.title
        })
        Tabs.PlaceTab = MainSection:Tab({
            Title = Constants.TABS.AUTO_PLACE.title
        })
        Tabs.HatchTab = MainSection:Tab({
            Title = Constants.TABS.AUTO_HATCH.title
        })
        Tabs.ClaimTab = MainSection:Tab({
            Title = Constants.TABS.AUTO_CLAIM.title
        })
        Tabs.ShopTab = MainSection:Tab({
            Title = Constants.TABS.SHOP.title
        })
        Tabs.PackTab = MainSection:Tab({
            Title = Constants.TABS.PACKS.title
        })
        Tabs.FruitTab = MainSection:Tab({
            Title = Constants.TABS.FRUIT.title
        })
        Tabs.FeedTab = MainSection:Tab({
            Title = Constants.TABS.FEED.title
        })
        Tabs.SaveTab = MainSection:Tab({
            Title = Constants.TABS.SAVE.title
        })

        return {
            WindUI = WindUI,
            Window = Window,
            Config = Config,
            Tabs = Tabs
        }
    end

    function UIManager.notify(options)
        if WindUI then
            WindUI:Notify(options)
        end
    end

    function UIManager.setupCloseHandler(callback)
        if Window then
            Window:OnClose(callback)
        end
    end

    function UIManager.setupOpenButton()
        Window:EditOpenButton({
            Title = "Build A Zoo",
            Icon = "monitor",
            CornerRadius = UDim.new(0, 16),
            StrokeThickness = 2,
            Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
            OnlyMobile = false,
            Enabled = true,
            Draggable = true
        })
    end
end

-- ============================================================================
-- MAIN APPLICATION
-- ============================================================================

local function initializeApplication()
    print("🔄 Initializing Build A Zoo...")

    -- Initialize game configs
    GameConfig.initializeAll()

    -- Initialize UI
    local ui = UIManager.initialize()
    local WindUI = ui.WindUI
    local Window = ui.Window
    local Config = ui.Config
    local Tabs = ui.Tabs

    -- Setup enhanced open button
    UIManager.setupOpenButton()

    -- Create Auto Buy tab
    local function createAutoBuyTab()
        -- Egg Selection UI Button
        Tabs.AutoTab:Button({
            Title = "🥚 Open Egg Selection UI",
            Desc = "Open the modern glass-style egg selection interface",
            Callback = function()
                local eggSelectionVisible = StateManager.isUIVisible("eggSelectionVisible")
                if not eggSelectionVisible then
                    -- Load egg selection UI
                    local EggSelection = loadstring(game:HttpGet(Constants.URLS.EGG_SELECTION))()
                    EggSelection.Show(function(selectedItems)
                        local selectedTypeSet = {}
                        local selectedMutationSet = {}

                        if selectedItems then
                            for itemId, isSelected in pairs(selectedItems) do
                                if isSelected then
                                    if GameConfig.EggData[itemId] then
                                        selectedTypeSet[itemId] = true
                                    elseif GameConfig.MutationData[itemId] then
                                        selectedMutationSet[itemId] = true
                                    end
                                end
                            end
                        end

                        StateManager.setSelection("selectedTypeSet", selectedTypeSet)
                        StateManager.setSelection("selectedMutationSet", selectedMutationSet)

                        SettingsManager.updateCustomUISelection("eggSelections", {
                            eggs = selectedTypeSet,
                            mutations = selectedMutationSet
                        })
                    end, function(isVisible)
                        StateManager.setUIVisible("eggSelectionVisible", isVisible)
                    end, StateManager.getSelection("selectedTypeSet"), StateManager.getSelection("selectedMutationSet"))
                    StateManager.setUIVisible("eggSelectionVisible", true)
                else
                    StateManager.setUIVisible("eggSelectionVisible", false)
                end
            end
        })

        -- Auto Buy Toggle
        local autoBuyToggle = Tabs.AutoTab:Toggle({
            Title = "🥚 Auto Buy Eggs",
            Desc = "Instantly buys eggs as soon as they appear on the conveyor belt!",
            Value = false,
            Callback = function(state)
                StateManager.setAutomationEnabled("autoBuyEnabled", state)

                SettingsManager.waitForSettingsReady(0.2)
                if state and not StateManager.getThread("autoBuyThread") then
                    local thread = task.spawn(function()
                        AutoBuySystem.runAutoBuy()
                        StateManager.setThread("autoBuyThread", nil)
                    end)
                    StateManager.setThread("autoBuyThread", thread)
                    UIManager.notify({
                        Title = "🥚 Auto Buy",
                        Content = "Started - Watching for eggs! 🎉",
                        Duration = 3
                    })
                elseif (not state) and StateManager.getThread("autoBuyThread") then
                    AutoBuySystem.cleanup()
                    UIManager.notify({
                        Title = "🥚 Auto Buy",
                        Content = "Stopped",
                        Duration = 3
                    })
                end
            end
        })

        Config:Register("autoBuyEnabled", autoBuyToggle)
    end

    -- Create other tabs (placeholder for now)
    local function createOtherTabs()
        Tabs.PlaceTab:Button({
            Title = "🏠 Auto Place Feature",
            Desc = "Auto place functionality (to be implemented)",
            Callback = function()
                UIManager.notify({
                    Title = "🏠 Auto Place",
                    Content = "Feature coming soon!",
                    Duration = 3
                })
            end
        })

        Tabs.HatchTab:Button({
            Title = "⚡ Auto Hatch Feature",
            Desc = "Auto hatch functionality (to be implemented)",
            Callback = function()
                UIManager.notify({
                    Title = "⚡ Auto Hatch",
                    Content = "Feature coming soon!",
                    Duration = 3
                })
            end
        })

        Tabs.SaveTab:Button({
            Title = "💾 Save Settings",
            Desc = "Save all your current settings",
            Callback = function()
                Config:Save()
                SettingsManager.saveAllSettings()
                UIManager.notify({
                    Title = "💾 Settings Saved",
                    Content = "All your settings have been saved! 🎉",
                    Duration = 3
                })
            end
        })

        Tabs.SaveTab:Button({
            Title = "📂 Load Settings",
            Desc = "Load your saved settings",
            Callback = function()
                Config:Load()
                SettingsManager.loadAllSettings()
                UIManager.notify({
                    Title = "📂 Settings Loaded",
                    Content = "Your settings have been loaded! 🎉",
                    Duration = 3
                })
            end
        })
    end

    -- Create UI tabs
    createAutoBuyTab()
    createOtherTabs()

    -- Setup close handler
    UIManager.setupCloseHandler(function()
        StateManager.setAutomationEnabled("autoBuyEnabled", false)
        AutoBuySystem.cleanup()
    end)

    -- Auto-load settings
    task.spawn(function()
        task.wait(Constants.DELAYS.SETTINGS_LOAD_WAIT)

        UIManager.notify({
            Title = "📂 Loading Settings",
            Content = "Loading your saved settings...",
            Duration = 2
        })

        Config:Load()
        SettingsManager.loadAllSettings()

        UIManager.notify({
            Title = "📂 Auto-Load Complete",
            Content = "Your saved settings have been loaded! 🎉",
            Duration = 3
        })

        StateManager.setSettingsLoaded(true)
    end)

    -- Success notification
    UIManager.notify({
        Title = "🎉 Build A Zoo",
        Content = "Successfully loaded! Ready to automate your zoo! 🦁",
        Duration = 5
    })

    print("✅ Build A Zoo initialized successfully!")
end

-- Start the application
initializeApplication()

-- Return API for external access
return {
    GameServices = GameServices,
    GameConfig = GameConfig,
    PlayerUtils = PlayerUtils,
    StateManager = StateManager,
    SettingsManager = SettingsManager,
    RemoteService = RemoteService,
    UIManager = UIManager,
    AutoBuySystem = AutoBuySystem
}
