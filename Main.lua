-- Main.lua
-- Main application entry point - Clean, modular version of 7Test.lua
-- Core modules
local GameServices = require(script.Core.GameServices)
local GameConfig = require(script.Core.GameConfig)
local PlayerUtils = require(script.Core.PlayerUtils)
local StateManager = require(script.Core.StateManager)
local SettingsManager = require(script.Core.SettingsManager)
local RemoteService = require(script.Core.RemoteService)
local Constants = require(script.Core.Constants)

-- UI modules
local UIManager = require(script.UI.UIManager)

-- System modules
local AutoBuySystem = require(script.Systems.AutoBuySystem)

-- Initialize the application
local function initializeApplication()
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
                        -- Handle selection changes
                        local selectedTypeSet = {}
                        local selectedMutationSet = {}

                        if selectedItems then
                            for itemId, isSelected in pairs(selectedItems) do
                                if isSelected then
                                    -- Check if it's an egg or mutation
                                    if GameConfig.EggData[itemId] then
                                        selectedTypeSet[itemId] = true
                                    elseif GameConfig.MutationData[itemId] then
                                        selectedMutationSet[itemId] = true
                                    end
                                end
                            end
                        end

                        -- Update state
                        StateManager.setSelection("selectedTypeSet", selectedTypeSet)
                        StateManager.setSelection("selectedMutationSet", selectedMutationSet)

                        -- Auto-save the selections
                        SettingsManager.updateCustomUISelection("eggSelections", {
                            eggs = selectedTypeSet,
                            mutations = selectedMutationSet
                        })
                    end, function(isVisible)
                        StateManager.setUIVisible("eggSelectionVisible", isVisible)
                    end, StateManager.getSelection("selectedTypeSet"), -- Pass saved egg selections
                    StateManager.getSelection("selectedMutationSet") -- Pass saved mutation selections
                    )
                    StateManager.setUIVisible("eggSelectionVisible", true)
                else
                    -- Hide the UI
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

        -- Register with config
        Config:Register("autoBuyEnabled", autoBuyToggle)
    end

    -- Create other tabs (placeholder for now)
    local function createOtherTabs()
        -- Auto Place Tab
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

        -- Auto Hatch Tab
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

        -- Settings Tab
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
        -- Cleanup all automation systems
        StateManager.setAutomationEnabled("autoBuyEnabled", false)
        AutoBuySystem.cleanup()
        -- Add other cleanup calls here
    end)

    -- Auto-load settings
    task.spawn(function()
        task.wait(Constants.DELAYS.SETTINGS_LOAD_WAIT)

        UIManager.notify({
            Title = "📂 Loading Settings",
            Content = "Loading your saved settings...",
            Duration = 2
        })

        -- Load settings
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
end

-- Start the application
initializeApplication()

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
