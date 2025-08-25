-- StateManager.lua
-- Centralized state management for the application
local StateManager = {}

-- Application state
local state = {
    -- UI State
    ui = {
        eggSelectionVisible = false,
        fruitSelectionVisible = false,
        feedFruitSelectionVisible = false,
        settingsLoaded = false
    },

    -- Automation State
    automation = {
        autoBuyEnabled = false,
        autoPlaceEnabled = false,
        autoHatchEnabled = false,
        autoClaimEnabled = false,
        autoFeedEnabled = false,
        autoUnlockEnabled = false,
        autoDeleteEnabled = false,
        autoDinoEnabled = false,
        autoUpgradeEnabled = false,
        autoBuyFruitEnabled = false,
        antiAFKEnabled = false
    },

    -- Selection State
    selections = {
        selectedTypeSet = {},
        selectedMutationSet = {},
        selectedFruits = {},
        selectedFeedFruits = {},
        selectedEggTypes = {},
        selectedMutations = {}
    },

    -- Threading State
    threads = {
        autoBuyThread = nil,
        autoPlaceThread = nil,
        autoHatchThread = nil,
        autoClaimThread = nil,
        autoFeedThread = nil,
        autoUnlockThread = nil,
        autoDeleteThread = nil,
        autoDinoThread = nil,
        autoUpgradeThread = nil,
        autoBuyFruitThread = nil
    },

    -- Configuration State
    config = {
        autoClaimDelay = 0.1,
        deleteSpeedThreshold = 100,
        lastDinoAt = 0
    },

    -- Placement State
    placement = {
        placingInProgress = false,
        availableEggs = {},
        availableTiles = {},
        buyingInProgress = false,
        placeConnections = {},
        beltConnections = {}
    },

    -- Shop State
    shop = {
        purchasedUpgrades = {},
        upgradesTried = 0,
        upgradesDone = 0,
        lastAction = "Ready to upgrade!"
    }
}

-- Getters
function StateManager.getUIState()
    return state.ui
end

function StateManager.getAutomationState()
    return state.automation
end

function StateManager.getSelectionState()
    return state.selections
end

function StateManager.getThreadState()
    return state.threads
end

function StateManager.getConfigState()
    return state.config
end

function StateManager.getPlacementState()
    return state.placement
end

function StateManager.getShopState()
    return state.shop
end

-- Individual state getters/setters
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

-- Configuration helpers
function StateManager.getConfig(configKey)
    return state.config[configKey]
end

function StateManager.setConfig(configKey, value)
    state.config[configKey] = value
end

-- Placement state helpers
function StateManager.isPlacingInProgress()
    return state.placement.placingInProgress
end

function StateManager.setPlacingInProgress(inProgress)
    state.placement.placingInProgress = inProgress
end

function StateManager.getAvailableEggs()
    return state.placement.availableEggs
end

function StateManager.setAvailableEggs(eggs)
    state.placement.availableEggs = eggs
end

function StateManager.getAvailableTiles()
    return state.placement.availableTiles
end

function StateManager.setAvailableTiles(tiles)
    state.placement.availableTiles = tiles
end

-- Shop state helpers
function StateManager.isPurchased(upgradeIndex)
    return state.shop.purchasedUpgrades[upgradeIndex] or false
end

function StateManager.setPurchased(upgradeIndex, purchased)
    state.shop.purchasedUpgrades[upgradeIndex] = purchased
end

function StateManager.incrementUpgradesDone()
    state.shop.upgradesDone = state.shop.upgradesDone + 1
end

function StateManager.incrementUpgradesTried()
    state.shop.upgradesTried = state.shop.upgradesTried + 1
end

function StateManager.setShopLastAction(action)
    state.shop.lastAction = action
end

function StateManager.getShopLastAction()
    return state.shop.lastAction
end

-- Reset functions for cleanup
function StateManager.resetAutomationThreads()
    for threadName, _ in pairs(state.threads) do
        state.threads[threadName] = nil
    end
end

function StateManager.resetConnections()
    state.placement.placeConnections = {}
    state.placement.beltConnections = {}
end

function StateManager.resetShopUpgrades()
    state.shop.purchasedUpgrades = {}
    state.shop.upgradesTried = 0
    state.shop.upgradesDone = 0
    state.shop.lastAction = "Ready to upgrade!"
end

return StateManager
