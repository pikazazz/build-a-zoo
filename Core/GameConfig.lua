-- GameConfig.lua
-- Centralized game configuration management
local GameServices = require(script.Parent.GameServices)
local ReplicatedStorage = GameServices.ReplicatedStorage

local GameConfig = {}

-- Configuration cache
local configs = {
    eggConfig = {},
    conveyorConfig = {},
    petFoodConfig = {},
    mutationConfig = {}
}

-- Hardcoded data
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

GameConfig.FruitData = {
    Strawberry = {
        Price = "5,000"
    },
    Blueberry = {
        Price = "20,000"
    },
    Watermelon = {
        Price = "80,000"
    },
    Apple = {
        Price = "400,000"
    },
    Orange = {
        Price = "1,200,000"
    },
    Corn = {
        Price = "3,500,000"
    },
    Banana = {
        Price = "12,000,000"
    },
    Grape = {
        Price = "50,000,000"
    },
    Pear = {
        Price = "200,000,000"
    },
    Pineapple = {
        Price = "600,000,000"
    },
    GoldMango = {
        Price = "2,000,000,000"
    },
    BloodstoneCycad = {
        Price = "8,000,000,000"
    },
    ColossalPinecone = {
        Price = "40,000,000,000"
    },
    VoltGinkgo = {
        Price = "80,000,000,000"
    }
}

-- Config loading functions
function GameConfig.loadEggConfig()
    local success, cfg = pcall(function()
        local cfgFolder = ReplicatedStorage:WaitForChild("Config")
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

function GameConfig.loadConveyorConfig()
    local success, cfg = pcall(function()
        local cfgFolder = ReplicatedStorage:WaitForChild("Config")
        local module = cfgFolder:WaitForChild("ResConveyor")
        return require(module)
    end)
    if success and type(cfg) == "table" then
        configs.conveyorConfig = cfg
    else
        configs.conveyorConfig = {}
    end
    return configs.conveyorConfig
end

function GameConfig.loadPetFoodConfig()
    local success, cfg = pcall(function()
        local cfgFolder = ReplicatedStorage:WaitForChild("Config")
        local module = cfgFolder:WaitForChild("ResPetFood")
        return require(module)
    end)
    if success and type(cfg) == "table" then
        configs.petFoodConfig = cfg
    else
        configs.petFoodConfig = {}
    end
    return configs.petFoodConfig
end

function GameConfig.loadMutationConfig()
    local success, cfg = pcall(function()
        local cfgFolder = ReplicatedStorage:WaitForChild("Config")
        local module = cfgFolder:WaitForChild("ResMutate")
        return require(module)
    end)
    if success and type(cfg) == "table" then
        configs.mutationConfig = cfg
    else
        configs.mutationConfig = {}
    end
    return configs.mutationConfig
end

-- Getters for configs
function GameConfig.getEggConfig()
    return configs.eggConfig
end

function GameConfig.getConveyorConfig()
    return configs.conveyorConfig
end

function GameConfig.getPetFoodConfig()
    return configs.petFoodConfig
end

function GameConfig.getMutationConfig()
    return configs.mutationConfig
end

-- Initialize all configs
function GameConfig.initializeAll()
    GameConfig.loadEggConfig()
    GameConfig.loadConveyorConfig()
    GameConfig.loadPetFoodConfig()
    GameConfig.loadMutationConfig()
end

return GameConfig
