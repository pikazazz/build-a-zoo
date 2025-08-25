-- Roblox Script Hub Demo
-- Gen Z Glassmorphism UI for Roblox Script Hubs
local GlassmorphismUI = require("UI.GlassmorphismUI")
local ThemeSystem = require("UI.ThemeSystem")
local UIUtils = require("UI.UIUtils")

-- Create UI instances
local ui = GlassmorphismUI.new()
local themes = ThemeSystem.new()

-- Roblox Script Hub Demo
local RobloxHubDemo = {}

-- Script categories for the hub
local SCRIPT_CATEGORIES = {{
    name = "🎮 Game Scripts",
    scripts = {{
        name = "Auto Farm",
        description = "Automatic farming for popular games",
        status = "Working"
    }, {
        name = "Speed Hack",
        description = "Increase player movement speed",
        status = "Updated"
    }, {
        name = "Jump Boost",
        description = "Enhanced jumping abilities",
        status = "Working"
    }, {
        name = "Teleport GUI",
        description = "Teleport to any location",
        status = "New"
    }}
}, {
    name = "🔥 Popular",
    scripts = {{
        name = "Universal ESP",
        description = "See players through walls",
        status = "Hot"
    }, {
        name = "Aimbot",
        description = "Auto-aim for shooter games",
        status = "Working"
    }, {
        name = "Fly Script",
        description = "Enable flying in any game",
        status = "Updated"
    }, {
        name = "Noclip",
        description = "Walk through walls",
        status = "Working"
    }}
}, {
    name = "🛠️ Utilities",
    scripts = {{
        name = "Chat Spammer",
        description = "Spam chat with custom messages",
        status = "Working"
    }, {
        name = "Anti-AFK",
        description = "Prevent getting kicked for being idle",
        status = "New"
    }, {
        name = "FPS Booster",
        description = "Optimize game performance",
        status = "Updated"
    }, {
        name = "Auto Clicker",
        description = "Automatic clicking tool",
        status = "Working"
    }}
}, {
    name = "🎯 Exploits",
    scripts = {{
        name = "Infinite Yield",
        description = "Admin commands for any game",
        status = "Hot"
    }, {
        name = "Dark Dex",
        description = "Advanced game explorer",
        status = "Working"
    }, {
        name = "Remote Spy",
        description = "Monitor game network traffic",
        status = "Updated"
    }, {
        name = "Script Builder",
        description = "Execute custom Lua scripts",
        status = "New"
    }}
}}

-- Create main script hub interface
function RobloxHubDemo.createScriptHub()
    print("🚀 Creating Roblox Script Hub Interface...")
    print("💜 Theme: Gen Z Glassmorphism")
    print("🎯 Target: Roblox Script Hub Users")
    print("")

    local components = {}

    -- Main hub window (modal-style)
    local hubWindow =
        ui:createModal(1200, 800, "🎮 Elite Script Hub v2.0", "The most fire script hub for Roblox! ✨")
    hubWindow.isVisible = true
    themes:applyTheme(hubWindow, "genZ")

    -- Top navigation bar
    local navbar = ui:createNavbar(1200, 70, {{
        text = "Home",
        icon = "🏠",
        active = true
    }, {
        text = "Scripts",
        icon = "📜",
        active = false
    }, {
        text = "Favorites",
        icon = "⭐",
        active = false
    }, {
        text = "Settings",
        icon = "⚙️",
        active = false
    }, {
        text = "Discord",
        icon = "💬",
        active = false
    }})
    themes:applyTheme(navbar, "genZ")

    -- Search bar
    local searchBar = ui:createInput(50, 90, 400, 45, "Search scripts... 🔍")
    themes:applyTheme(searchBar, "genZ")

    -- Filter buttons
    local filterButtons = {}
    local filterOptions = {"All", "Working", "Updated", "New", "Hot"}
    for i, filter in ipairs(filterOptions) do
        local btn = ui:createButton(470 + (i - 1) * 120, 90, 110, 45, filter, function()
            print("🔍 Filtering by: " .. filter)
            RobloxHubDemo.filterScripts(filter)
        end)
        themes:applyTheme(btn, "genZ")
        table.insert(filterButtons, btn)
    end

    -- Script category cards
    local categoryCards = {}
    local startY = 160

    for i, category in ipairs(SCRIPT_CATEGORIES) do
        local row = math.floor((i - 1) / 2)
        local col = (i - 1) % 2

        local cardX = 50 + col * 580
        local cardY = startY + row * 280

        local card = ui:createCard(cardX, cardY, 550, 260, category.name,
            string.format("💫 %d scripts available", #category.scripts))
        themes:applyTheme(card, "genZ")

        -- Add script buttons to category
        local scriptButtons = {}
        for j, script in ipairs(category.scripts) do
            if j <= 4 then -- Show max 4 scripts per category
                local btnX = cardX + 20 + ((j - 1) % 2) * 250
                local btnY = cardY + 80 + math.floor((j - 1) / 2) * 60

                local statusEmoji = script.status == "Hot" and "🔥" or script.status == "New" and "✨" or
                                        script.status == "Updated" and "🆙" or "✅"

                local scriptBtn = ui:createButton(btnX, btnY, 240, 50, script.name .. " " .. statusEmoji, function()
                    RobloxHubDemo.executeScript(script)
                end)
                themes:applyTheme(scriptBtn, "genZ")
                table.insert(scriptButtons, scriptBtn)
            end
        end

        category.buttons = scriptButtons
        table.insert(categoryCards, card)
    end

    -- Bottom status bar
    local statusBar = ui:createCard(50, 720, 1100, 60, "Status",
        "🟢 Hub Status: Online | 👥 Users: 2,847 | 🚀 Scripts Loaded: 156")
    themes:applyTheme(statusBar, "genZ")

    -- User profile section
    local profileCard = ui:createCard(1160, 90, 200, 300, "👤 Profile",
        "Username: ProGamer\nRank: VIP\nScripts Used: 42\nJoined: Jan 2024")
    themes:applyTheme(profileCard, "genZ")

    -- Quick action buttons
    local quickActions = {}
    local actions = {{
        name = "Execute",
        icon = "▶️",
        color = "primary"
    }, {
        name = "Copy",
        icon = "📋",
        color = "secondary"
    }, {
        name = "Save",
        icon = "💾",
        color = "accent"
    }}

    for i, action in ipairs(actions) do
        local btn = ui:createButton(1160, 400 + (i - 1) * 60, 200, 50, action.icon .. " " .. action.name, function()
            print("🎯 " .. action.name .. " action triggered!")
        end)
        themes:applyTheme(btn, "genZ")
        table.insert(quickActions, btn)
    end

    components.hubWindow = hubWindow
    components.navbar = navbar
    components.searchBar = searchBar
    components.filterButtons = filterButtons
    components.categoryCards = categoryCards
    components.statusBar = statusBar
    components.profileCard = profileCard
    components.quickActions = quickActions

    print("✅ Script Hub Interface Created!")
    print("🎨 Total Components: " .. (1 + 1 + 1 + #filterButtons + #categoryCards + 1 + 1 + #quickActions))

    return components
end

-- Execute script function
function RobloxHubDemo.executeScript(script)
    print("🚀 Executing Script: " .. script.name)
    print("📝 Description: " .. script.description)
    print("✅ Status: " .. script.status)

    -- Simulate script execution
    local loadingModal = ui:createModal(400, 200, "⚡ Executing Script",
        "Loading " .. script.name .. "...\nPlease wait...")
    loadingModal.isVisible = true
    themes:applyTheme(loadingModal, "genZ")

    -- Simulate loading animation
    print("💫 Script injection in progress...")
    print("🔄 Bypassing anti-cheat...")
    print("✨ Script loaded successfully!")
    print("🎉 " .. script.name .. " is now active!")

    -- Hide loading modal after execution
    loadingModal.isVisible = false
end

-- Filter scripts by status
function RobloxHubDemo.filterScripts(filter)
    print("🔍 Filtering scripts by: " .. filter)

    if filter == "All" then
        print("📋 Showing all available scripts")
    elseif filter == "Working" then
        print("✅ Showing only working scripts")
    elseif filter == "Updated" then
        print("🆙 Showing recently updated scripts")
    elseif filter == "New" then
        print("✨ Showing new scripts")
    elseif filter == "Hot" then
        print("🔥 Showing trending/popular scripts")
    end
end

-- Create settings panel
function RobloxHubDemo.createSettingsPanel()
    print("\n⚙️ Creating Settings Panel...")

    local settingsModal = ui:createModal(600, 500, "⚙️ Hub Settings", "Customize your script hub experience")
    settingsModal.isVisible = true
    themes:applyTheme(settingsModal, "genZ")

    -- Theme selector
    local themeCard = ui:createCard(50, 100, 500, 150, "🎨 Theme Selection", "Choose your preferred visual style")
    themes:applyTheme(themeCard, "genZ")

    local themeButtons = {}
    local availableThemes = {"genZ", "darkAesthetic", "cyberNeon", "retroWave"}

    for i, themeName in ipairs(availableThemes) do
        local btn = ui:createButton(70 + (i - 1) * 110, 180, 100, 40, themeName:gsub("(%l)(%u)", "%1 %2"), function()
            themes:setTheme(themeName)
            print("🎨 Theme changed to: " .. themeName)
        end)
        themes:applyTheme(btn, themeName)
        table.insert(themeButtons, btn)
    end

    -- Auto-execute settings
    local autoCard = ui:createCard(50, 270, 500, 120, "🤖 Auto Settings", "Configure automatic features")
    themes:applyTheme(autoCard, "genZ")

    local autoInject = ui:createButton(70, 320, 200, 40, "Auto Inject: ON", function()
        print("🔄 Toggled auto inject")
    end)
    themes:applyTheme(autoInject, "genZ")

    local autoUpdate = ui:createButton(280, 320, 200, 40, "Auto Update: ON", function()
        print("🔄 Toggled auto update")
    end)
    themes:applyTheme(autoUpdate, "genZ")

    -- Save settings button
    local saveBtn = ui:createButton(250, 420, 150, 50, "💾 Save Settings", function()
        print("💾 Settings saved successfully!")
        settingsModal.isVisible = false
    end)
    themes:applyTheme(saveBtn, "genZ")

    return {
        modal = settingsModal,
        themeCard = themeCard,
        themeButtons = themeButtons,
        autoCard = autoCard,
        autoButtons = {autoInject, autoUpdate},
        saveButton = saveBtn
    }
end

-- Run the complete Roblox script hub demo
function RobloxHubDemo.run()
    print("🎮 Starting Roblox Script Hub Demo")
    print("=" .. string.rep("=", 50))
    print("🌟 Welcome to Elite Script Hub v2.0!")
    print("💜 Featuring Gen Z Glassmorphism Design")
    print("🚀 The most fire UI for Roblox scripts!")
    print("")

    -- Create main interface
    local mainInterface = RobloxHubDemo.createScriptHub()

    -- Simulate user interactions
    print("\n🖱️  Simulating user interactions...")

    -- User searches for a script
    mainInterface.searchBar.value = "speed hack"
    print("🔍 User searched for: 'speed hack'")

    -- User hovers over a script button
    ui:handleMouseMove(150, 300)
    print("💫 Hovering over script button - glass effect activated")

    -- User clicks on a popular script
    print("\n🎯 User clicks on 'Universal ESP' script...")
    RobloxHubDemo.executeScript({
        name = "Universal ESP",
        description = "See players through walls",
        status = "Hot"
    })

    -- Show settings panel
    print("\n⚙️ Opening settings panel...")
    local settingsPanel = RobloxHubDemo.createSettingsPanel()

    -- Update animations
    for i = 1, 15 do
        ui:update()
        if i % 5 == 0 then
            print("⚡ Animations running smoothly... Frame " .. i)
        end
    end

    -- Render complete interface
    print("\n🎨 Rendering Roblox Script Hub Interface:")
    ui:render()

    -- Show feature highlights
    print("\n✨ Script Hub Features:")
    print("  🎮 156+ Premium Scripts")
    print("  🔥 Real-time Status Updates")
    print("  💫 Glassmorphism UI Effects")
    print("  🚀 One-Click Script Execution")
    print("  ⭐ Favorites & Custom Lists")
    print("  🎨 Multiple Visual Themes")
    print("  👥 2,847+ Active Users")
    print("  🛡️ Anti-Detection System")

    print("\n🎉 Roblox Script Hub Demo Completed!")
    print("💎 Ready for production use!")
    print("🔗 Perfect for script hub developers!")
end

-- Additional utility functions for Roblox-specific features
function RobloxHubDemo.createScriptEditor()
    local editor = ui:createModal(800, 600, "📝 Script Editor", "Write and test your own scripts")
    themes:applyTheme(editor, "genZ")

    local codeArea = ui:createInput(50, 100, 700, 400, "-- Write your Lua script here\nprint('Hello, Roblox!')")
    themes:applyTheme(codeArea, "genZ")

    local executeBtn = ui:createButton(50, 520, 150, 50, "▶️ Execute", function()
        print("🚀 Executing custom script...")
    end)
    themes:applyTheme(executeBtn, "genZ")

    return {
        editor = editor,
        codeArea = codeArea,
        executeButton = executeBtn
    }
end

function RobloxHubDemo.createDiscordIntegration()
    local discordCard = ui:createCard(50, 50, 400, 200, "💬 Discord Integration", "Connect with the community!")
    themes:applyTheme(discordCard, "genZ")

    local joinBtn = ui:createButton(70, 150, 180, 50, "🔗 Join Discord", function()
        print("🌐 Opening Discord invite...")
    end)
    themes:applyTheme(joinBtn, "genZ")

    return {
        card = discordCard,
        joinButton = joinBtn
    }
end

-- Export the demo
return RobloxHubDemo
