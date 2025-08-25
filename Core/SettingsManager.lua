-- SettingsManager.lua
-- Handle saving and loading of settings
local GameServices = require(script.Parent.GameServices)
local StateManager = require(script.Parent.StateManager)
local Constants = require(script.Parent.Constants)

local HttpService = GameServices.HttpService

local SettingsManager = {}

-- Settings loading/saving functions
function SettingsManager.loadAllSettings()
    -- Load WindUI config for simple UI elements
    -- This will be handled by the main application

    -- Load custom selection variables from JSON files
    SettingsManager.loadEggSelections()
    SettingsManager.loadFruitSelections()
    SettingsManager.loadFeedFruitSelections()
    SettingsManager.loadAutoPlaceSelections()
end

function SettingsManager.loadEggSelections()
    local success, data = pcall(function()
        if isfile(Constants.FILES.EGG_SELECTIONS) then
            local jsonData = readfile(Constants.FILES.EGG_SELECTIONS)
            return HttpService:JSONDecode(jsonData)
        end
    end)

    if success and data then
        local selectedTypeSet = {}
        if data.eggs then
            for _, eggId in ipairs(data.eggs) do
                selectedTypeSet[eggId] = true
            end
        end

        local selectedMutationSet = {}
        if data.mutations then
            for _, mutationId in ipairs(data.mutations) do
                selectedMutationSet[mutationId] = true
            end
        end

        StateManager.setSelection("selectedTypeSet", selectedTypeSet)
        StateManager.setSelection("selectedMutationSet", selectedMutationSet)
    end
end

function SettingsManager.loadFruitSelections()
    local success, data = pcall(function()
        if isfile(Constants.FILES.FRUIT_SELECTIONS) then
            local jsonData = readfile(Constants.FILES.FRUIT_SELECTIONS)
            return HttpService:JSONDecode(jsonData)
        end
    end)

    if success and data then
        local selectedFruits = {}
        if data.fruits then
            for _, fruitId in ipairs(data.fruits) do
                selectedFruits[fruitId] = true
            end
        end
        StateManager.setSelection("selectedFruits", selectedFruits)
    end
end

function SettingsManager.loadFeedFruitSelections()
    local success, data = pcall(function()
        if isfile(Constants.FILES.FEED_FRUIT_SELECTIONS) then
            local jsonData = readfile(Constants.FILES.FEED_FRUIT_SELECTIONS)
            return HttpService:JSONDecode(jsonData)
        end
    end)

    if success and data then
        local selectedFeedFruits = {}
        if data.fruits then
            for _, fruitId in ipairs(data.fruits) do
                selectedFeedFruits[fruitId] = true
            end
        end
        StateManager.setSelection("selectedFeedFruits", selectedFeedFruits)
    end
end

function SettingsManager.loadAutoPlaceSelections()
    local success, data = pcall(function()
        if isfile(Constants.FILES.AUTO_PLACE_SELECTIONS) then
            local jsonData = readfile(Constants.FILES.AUTO_PLACE_SELECTIONS)
            return HttpService:JSONDecode(jsonData)
        end
    end)

    if success and data then
        if data.eggTypes then
            StateManager.setSelection("selectedEggTypes", data.eggTypes)
        end
        if data.mutations then
            StateManager.setSelection("selectedMutations", data.mutations)
        end
    end
end

function SettingsManager.saveAllSettings()
    SettingsManager.saveEggSelections()
    SettingsManager.saveFruitSelections()
    SettingsManager.saveFeedFruitSelections()
    SettingsManager.saveAutoPlaceSelections()
end

function SettingsManager.saveEggSelections()
    local selectedTypeSet = StateManager.getSelection("selectedTypeSet")
    local selectedMutationSet = StateManager.getSelection("selectedMutationSet")

    local eggSelections = {
        eggs = {},
        mutations = {}
    }

    for eggId, _ in pairs(selectedTypeSet) do
        table.insert(eggSelections.eggs, eggId)
    end

    for mutationId, _ in pairs(selectedMutationSet) do
        table.insert(eggSelections.mutations, mutationId)
    end

    pcall(function()
        writefile(Constants.FILES.EGG_SELECTIONS, HttpService:JSONEncode(eggSelections))
    end)
end

function SettingsManager.saveFruitSelections()
    local selectedFruits = StateManager.getSelection("selectedFruits")

    local fruitSelections = {
        fruits = {}
    }

    for fruitId, _ in pairs(selectedFruits) do
        table.insert(fruitSelections.fruits, fruitId)
    end

    pcall(function()
        writefile(Constants.FILES.FRUIT_SELECTIONS, HttpService:JSONEncode(fruitSelections))
    end)
end

function SettingsManager.saveFeedFruitSelections()
    local selectedFeedFruits = StateManager.getSelection("selectedFeedFruits")

    local feedFruitSelections = {
        fruits = {}
    }

    for fruitId, _ in pairs(selectedFeedFruits) do
        table.insert(feedFruitSelections.fruits, fruitId)
    end

    pcall(function()
        writefile(Constants.FILES.FEED_FRUIT_SELECTIONS, HttpService:JSONEncode(feedFruitSelections))
    end)
end

function SettingsManager.saveAutoPlaceSelections()
    local selectedEggTypes = StateManager.getSelection("selectedEggTypes")
    local selectedMutations = StateManager.getSelection("selectedMutations")

    local autoPlaceSelections = {
        eggTypes = selectedEggTypes,
        mutations = selectedMutations
    }

    pcall(function()
        writefile(Constants.FILES.AUTO_PLACE_SELECTIONS, HttpService:JSONEncode(autoPlaceSelections))
    end)
end

-- Custom UI selections management
function SettingsManager.updateCustomUISelection(uiType, selections)
    -- This function will be called by UI modules to save their selections
    if uiType == "eggSelections" then
        StateManager.setSelection("selectedTypeSet", selections.eggs or {})
        StateManager.setSelection("selectedMutationSet", selections.mutations or {})
        SettingsManager.saveEggSelections()
    elseif uiType == "fruitSelections" then
        StateManager.setSelection("selectedFruits", selections)
        SettingsManager.saveFruitSelections()
    elseif uiType == "feedFruitSelections" then
        StateManager.setSelection("selectedFeedFruits", selections)
        SettingsManager.saveFeedFruitSelections()
    end
end

-- Wait for settings to be ready
function SettingsManager.waitForSettingsReady(extraDelay)
    while not StateManager.areSettingsLoaded() do
        task.wait(0.1)
    end
    if extraDelay and extraDelay > 0 then
        task.wait(extraDelay)
    end
end

return SettingsManager
