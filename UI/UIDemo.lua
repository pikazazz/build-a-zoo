-- Gen Z Glassmorphism UI Demo
-- Example usage of the modern glassmorphism UI components
local GlassmorphismUI = require("UI.GlassmorphismUI")

-- Create UI instance
local ui = GlassmorphismUI.new()

-- Demo function to showcase the UI components
function createGenZInterface()
    print("🎉 Creating Gen Z Glassmorphism Interface...")
    print("💜 Primary Color: Electric Purple (#8A2BE2)")
    print("💎 Secondary Color: Neon Cyan (#00FFFF)")
    print("")

    -- Create a modern navbar
    local navbar = ui:createNavbar(1920, 80, {{
        text = "Home",
        icon = "🏠"
    }, {
        text = "Explore",
        icon = "🔍"
    }, {
        text = "Create",
        icon = "✨"
    }, {
        text = "Profile",
        icon = "👤"
    }})

    -- Create glassmorphism buttons with gen Z vibes
    local playButton = ui:createButton(100, 150, 200, 60, "Let's Go! 🚀", function()
        print("🎮 Play button clicked! Time to vibe!")
    end)

    local shopButton = ui:createButton(320, 150, 200, 60, "Shop Fits 💎", function()
        print("🛍️ Opening the drip store!")
    end)

    local socialButton = ui:createButton(540, 150, 200, 60, "Connect 🤝", function()
        print("📱 Let's connect and share the energy!")
    end)

    -- Create content cards
    local profileCard = ui:createCard(100, 250, 300, 400, "Your Vibe ✨",
        "Level up your digital presence with our glassmorphism interface. " ..
            "Clean, modern, and absolutely fire! 🔥")

    local statsCard = ui:createCard(420, 250, 300, 400, "Stats That Slap 📊",
        "Track your progress, achievements, and flex on the leaderboards. " ..
            "Data visualization that actually looks good! 📈")

    local trendsCard = ui:createCard(740, 250, 300, 400, "What's Trending 📈",
        "Stay updated with the latest trends, memes, and whatever's going viral. " .. "Always be in the know! 👀")

    -- Create modern input fields
    local searchInput = ui:createInput(100, 680, 400, 50, "Search for anything... 🔍")
    local usernameInput = ui:createInput(520, 680, 300, 50, "Your username 👤")
    local emailInput = ui:createInput(840, 680, 300, 50, "Email address 📧")

    -- Create a modal for special interactions
    local welcomeModal = ui:createModal(600, 400, "Welcome to the Future! 🌟",
        "Experience the next level of UI design with glassmorphism effects, " ..
            "smooth animations, and gen Z aesthetics. Ready to level up? 🚀")

    print("✅ Interface created successfully!")
    print("🎨 All components feature glassmorphism effects")
    print("💫 Smooth animations and hover states included")
    print("🌈 Gen Z color palette with electric purple and neon cyan")
    print("")

    return {
        navbar = navbar,
        buttons = {playButton, shopButton, socialButton},
        cards = {profileCard, statsCard, trendsCard},
        inputs = {searchInput, usernameInput, emailInput},
        modal = welcomeModal
    }
end

-- Simulate main application loop
function runDemo()
    print("🎮 Starting Gen Z Glassmorphism UI Demo")
    print("=" .. string.rep("=", 50))

    -- Create the interface
    local interface = createGenZInterface()

    -- Simulate some interactions
    print("\n🖱️  Simulating user interactions...")

    -- Simulate mouse hover on buttons
    ui:handleMouseMove(150, 180) -- Hover over play button
    print("💫 Hovering over 'Let's Go!' button - blur effect activated")

    -- Simulate button click
    ui:handleMouseClick(150, 180) -- Click play button

    -- Show the modal
    interface.modal.isVisible = true
    print("🌟 Welcome modal displayed")

    -- Update animations
    for i = 1, 10 do
        ui:update()
        if i == 5 then
            print("⚡ Animations running smoothly...")
        end
    end

    -- Render the complete interface
    print("\n🎨 Rendering complete interface:")
    ui:render()

    print("\n✨ Demo completed successfully!")
    print("🎉 Your gen Z glassmorphism UI is ready to use!")
end

-- Additional utility functions for customization
function createCustomButton(text, emoji, x, y)
    return ui:createButton(x, y, 180, 55, text .. " " .. emoji, function()
        print("🎯 Custom button '" .. text .. "' was clicked!")
    end)
end

function createCustomCard(title, emoji, content, x, y)
    return ui:createCard(x, y, 280, 350, emoji .. " " .. title, content)
end

-- Export functions for external use
local UIDemo = {
    create = createGenZInterface,
    run = runDemo,
    ui = ui,
    createCustomButton = createCustomButton,
    createCustomCard = createCustomCard
}

-- If running this file directly, run the demo
if (...) == nil then
    runDemo()
end

return UIDemo
