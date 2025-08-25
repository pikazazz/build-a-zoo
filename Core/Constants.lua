-- Constants.lua
-- Application constants and configuration
local Constants = {}

-- UI Configuration
Constants.UI = {
    WINDOW_TITLE = "Build A Zoo",
    WINDOW_ICON = "app-window-mac",
    WINDOW_SIZE = UDim2.fromOffset(520, 360),
    AUTHOR = "Zebux",
    FOLDER = "Zebux",
    THEME = "Dark"
}

-- File Names
Constants.FILES = {
    EGG_SELECTIONS = "Zebux_EggSelections.json",
    FRUIT_SELECTIONS = "Zebux_FruitSelections.json",
    FEED_FRUIT_SELECTIONS = "Zebux_FeedFruitSelections.json",
    AUTO_PLACE_SELECTIONS = "Zebux_AutoPlaceSelections.json",
    CUSTOM_SELECTIONS = "Zebux_CustomSelections.json"
}

-- Automation Delays
Constants.DELAYS = {
    AUTO_CLAIM_DEFAULT = 0.1,
    AUTO_PLACE_BETWEEN_ATTEMPTS = 0.2,
    AUTO_HATCH_BETWEEN_EGGS = 0.2,
    AUTO_BUY_CHECK_INTERVAL = 0.5,
    SETTINGS_LOAD_WAIT = 3.0
}

-- Placement Configuration
Constants.PLACEMENT = {
    EGG_HEIGHT_OFFSET = 12, -- Eggs float 12 studs above tile surface
    TILE_SIZE = 8, -- Farm tiles are 8x8x8
    OCCUPANCY_CHECK_RADIUS_XZ = 4.0,
    OCCUPANCY_CHECK_RADIUS_Y = 8.0,
    MIN_DISTANCE_DEFAULT = 6
}

-- Dino Event
Constants.DINO = {
    CLAIM_DEBOUNCE = 2, -- seconds between claims
    CHECK_INTERVAL = 1 -- seconds between status checks
}

-- Priority System (if needed in future)
Constants.PRIORITY = {
    AUTO_PLACE = 1,
    AUTO_HATCH = 2,
    AUTO_BUY = 3
}

-- URLs for external resources
Constants.URLS = {
    WINDUI = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
    EGG_SELECTION = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/EggSelection.lua",
    FRUIT_SELECTION = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/FruitSelection.lua",
    FEED_FRUIT_SELECTION = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/FeedFruitSelection.lua",
    AUTO_FEED_SYSTEM = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/AutoFeedSystem.lua",
    AUTO_QUEST_SYSTEM = "https://raw.githubusercontent.com/ZebuxHub/Main/refs/heads/main/AutoQuestSystem.lua"
}

-- Tab Icons and Titles
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

return Constants
