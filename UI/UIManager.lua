-- UIManager.lua
-- Manages the main UI creation and organization
local GameServices = require(script.Parent.Parent.Core.GameServices)
local StateManager = require(script.Parent.Parent.Core.StateManager)
local SettingsManager = require(script.Parent.Parent.Core.SettingsManager)
local Constants = require(script.Parent.Parent.Core.Constants)

local UIManager = {}

-- UI References
local WindUI = nil
local Window = nil
local ConfigManager = nil
local Config = nil
local Tabs = {}

-- Initialize the UI system
function UIManager.initialize()
    -- Load WindUI library
    WindUI = loadstring(game:HttpGet(Constants.URLS.WINDUI))()

    -- Create main window
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

    -- Setup config manager
    ConfigManager = Window.ConfigManager
    Config = ConfigManager:CreateConfig("zebuxConfig")

    -- Create tabs
    UIManager.createTabs()

    return {
        WindUI = WindUI,
        Window = Window,
        Config = Config,
        Tabs = Tabs
    }
end

function UIManager.createTabs()
    -- Main section
    local MainSection = Window:Section({
        Title = "🤖 Auto Helpers",
        Opened = true
    })

    -- Create all tabs
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
end

function UIManager.getWindow()
    return Window
end

function UIManager.getWindUI()
    return WindUI
end

function UIManager.getConfig()
    return Config
end

function UIManager.getTabs()
    return Tabs
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
        Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true
    })
end

return UIManager
