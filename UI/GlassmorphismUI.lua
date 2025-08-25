-- Gen Z Glassmorphism UI Component
-- Modern, vibrant UI with glass effects and contemporary styling
local GlassmorphismUI = {}
GlassmorphismUI.__index = GlassmorphismUI

-- Gen Z Color Palette (Main Colors)
local COLORS = {
    -- Primary: Electric Purple/Violet 
    PRIMARY = {
        r = 138,
        g = 43,
        b = 226,
        a = 255 -- #8A2BE2 (BlueViolet)
    },

    -- Secondary: Neon Cyan/Aqua
    SECONDARY = {
        r = 0,
        g = 255,
        b = 255,
        a = 255 -- #00FFFF (Cyan)
    },

    -- Glass effect colors (with transparency)
    GLASS_PRIMARY = {
        r = 138,
        g = 43,
        b = 226,
        a = 80 -- Semi-transparent primary
    },

    GLASS_SECONDARY = {
        r = 0,
        g = 255,
        b = 255,
        a = 60 -- Semi-transparent secondary
    },

    -- Support colors
    WHITE = {
        r = 255,
        g = 255,
        b = 255,
        a = 255
    },

    BLACK = {
        r = 0,
        g = 0,
        b = 0,
        a = 255
    },

    GLASS_WHITE = {
        r = 255,
        g = 255,
        b = 255,
        a = 40
    },

    SHADOW = {
        r = 0,
        g = 0,
        b = 0,
        a = 30
    }
}

-- UI Component Types
local COMPONENT_TYPES = {
    BUTTON = "button",
    CARD = "card",
    INPUT = "input",
    MODAL = "modal",
    NAVBAR = "navbar"
}

-- Create new UI instance
function GlassmorphismUI.new()
    local self = setmetatable({}, GlassmorphismUI)
    self.components = {}
    self.animations = {}
    self.hover_states = {}
    return self
end

-- Utility function to create gradient effect
function GlassmorphismUI:createGradient(x, y, width, height, color1, color2, direction)
    direction = direction or "vertical"

    local gradient = {
        x = x,
        y = y,
        width = width,
        height = height,
        color1 = color1,
        color2 = color2,
        direction = direction,
        type = "gradient"
    }

    return gradient
end

-- Create glassmorphism button
function GlassmorphismUI:createButton(x, y, width, height, text, onClick)
    local button = {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        onClick = onClick,
        type = COMPONENT_TYPES.BUTTON,
        isHovered = false,
        isPressed = false,
        cornerRadius = 15,

        -- Glassmorphism properties
        blur = 10,
        backdrop = true,
        borderWidth = 1,
        borderColor = COLORS.GLASS_WHITE,

        -- Gradient background
        background = self:createGradient(x, y, width, height, COLORS.GLASS_PRIMARY, COLORS.GLASS_SECONDARY, "diagonal"),

        -- Shadow
        shadow = {
            offsetX = 0,
            offsetY = 8,
            blur = 25,
            color = COLORS.SHADOW
        }
    }

    table.insert(self.components, button)
    return button
end

-- Create glassmorphism card
function GlassmorphismUI:createCard(x, y, width, height, title, content)
    local card = {
        x = x,
        y = y,
        width = width,
        height = height,
        title = title,
        content = content,
        type = COMPONENT_TYPES.CARD,
        cornerRadius = 20,

        -- Glassmorphism properties
        blur = 15,
        backdrop = true,
        borderWidth = 1,
        borderColor = COLORS.GLASS_WHITE,

        -- Background with glass effect
        background = {
            color = COLORS.GLASS_WHITE,
            opacity = 0.1
        },

        -- Shadow
        shadow = {
            offsetX = 0,
            offsetY = 12,
            blur = 30,
            color = COLORS.SHADOW
        },

        -- Title styling
        titleStyle = {
            font = "bold",
            size = 18,
            color = COLORS.PRIMARY
        },

        -- Content styling
        contentStyle = {
            font = "regular",
            size = 14,
            color = COLORS.WHITE
        }
    }

    table.insert(self.components, card)
    return card
end

-- Create modern input field
function GlassmorphismUI:createInput(x, y, width, height, placeholder)
    local input = {
        x = x,
        y = y,
        width = width,
        height = height,
        placeholder = placeholder,
        value = "",
        type = COMPONENT_TYPES.INPUT,
        isFocused = false,
        cornerRadius = 12,

        -- Glassmorphism properties
        blur = 8,
        backdrop = true,
        borderWidth = 2,
        borderColor = COLORS.GLASS_PRIMARY,

        -- Background
        background = {
            color = COLORS.GLASS_WHITE,
            opacity = 0.05
        },

        -- Text styling
        textStyle = {
            font = "regular",
            size = 16,
            color = COLORS.WHITE
        },

        placeholderStyle = {
            font = "regular",
            size = 16,
            color = COLORS.GLASS_WHITE
        }
    }

    table.insert(self.components, input)
    return input
end

-- Create glassmorphism modal
function GlassmorphismUI:createModal(width, height, title, content)
    local screenWidth = 1920 -- Assume screen dimensions
    local screenHeight = 1080

    local modal = {
        x = (screenWidth - width) / 2,
        y = (screenHeight - height) / 2,
        width = width,
        height = height,
        title = title,
        content = content,
        type = COMPONENT_TYPES.MODAL,
        isVisible = false,
        cornerRadius = 25,

        -- Glassmorphism properties
        blur = 20,
        backdrop = true,
        borderWidth = 1,
        borderColor = COLORS.GLASS_WHITE,

        -- Background overlay
        overlay = {
            color = COLORS.BLACK,
            opacity = 0.4
        },

        -- Modal background
        background = self:createGradient(0, 0, width, height, COLORS.GLASS_PRIMARY, COLORS.GLASS_SECONDARY, "radial"),

        -- Shadow
        shadow = {
            offsetX = 0,
            offsetY = 20,
            blur = 50,
            color = COLORS.SHADOW
        }
    }

    table.insert(self.components, modal)
    return modal
end

-- Create modern navbar
function GlassmorphismUI:createNavbar(width, height, items)
    local navbar = {
        x = 0,
        y = 0,
        width = width,
        height = height,
        items = items or {},
        type = COMPONENT_TYPES.NAVBAR,
        cornerRadius = 0,

        -- Glassmorphism properties
        blur = 12,
        backdrop = true,
        borderWidth = 0,
        borderColor = COLORS.GLASS_WHITE,

        -- Background with glass effect
        background = {
            color = COLORS.GLASS_WHITE,
            opacity = 0.08
        },

        -- Bottom border for style
        bottomBorder = {
            width = 1,
            color = COLORS.GLASS_PRIMARY
        }
    }

    table.insert(self.components, navbar)
    return navbar
end

-- Animation system for smooth interactions
function GlassmorphismUI:animateComponent(component, property, targetValue, duration)
    local animation = {
        component = component,
        property = property,
        startValue = component[property],
        targetValue = targetValue,
        duration = duration or 0.3,
        startTime = os.clock(),
        isActive = true
    }

    table.insert(self.animations, animation)
end

-- Update animations
function GlassmorphismUI:updateAnimations()
    local currentTime = os.clock()

    for i = #self.animations, 1, -1 do
        local anim = self.animations[i]

        if anim.isActive then
            local elapsed = currentTime - anim.startTime
            local progress = math.min(elapsed / anim.duration, 1.0)

            -- Smooth easing function
            local easedProgress = 1 - math.pow(1 - progress, 3)

            -- Interpolate value
            local currentValue = anim.startValue + (anim.targetValue - anim.startValue) * easedProgress
            anim.component[anim.property] = currentValue

            -- Remove finished animations
            if progress >= 1.0 then
                table.remove(self.animations, i)
            end
        end
    end
end

-- Handle mouse events
function GlassmorphismUI:handleMouseMove(x, y)
    for _, component in ipairs(self.components) do
        if component.type == COMPONENT_TYPES.BUTTON then
            local isInside = x >= component.x and x <= component.x + component.width and y >= component.y and y <=
                                 component.y + component.height

            if isInside and not component.isHovered then
                component.isHovered = true
                -- Animate hover effect
                self:animateComponent(component, "blur", 15, 0.2)
                self:animateComponent(component.shadow, "blur", 35, 0.2)
            elseif not isInside and component.isHovered then
                component.isHovered = false
                -- Animate hover out
                self:animateComponent(component, "blur", 10, 0.2)
                self:animateComponent(component.shadow, "blur", 25, 0.2)
            end
        end
    end
end

function GlassmorphismUI:handleMouseClick(x, y)
    for _, component in ipairs(self.components) do
        if component.type == COMPONENT_TYPES.BUTTON and component.onClick then
            local isInside = x >= component.x and x <= component.x + component.width and y >= component.y and y <=
                                 component.y + component.height

            if isInside then
                -- Click animation
                self:animateComponent(component, "cornerRadius", 12, 0.1)
                component.onClick()

                -- Reset after click
                local resetTimer = coroutine.create(function()
                    coroutine.yield(0.1)
                    self:animateComponent(component, "cornerRadius", 15, 0.1)
                end)
                coroutine.resume(resetTimer)
            end
        end
    end
end

-- Render all components (pseudo-rendering for demonstration)
function GlassmorphismUI:render()
    print("🎨 Rendering Gen Z Glassmorphism UI Components:")

    for _, component in ipairs(self.components) do
        if component.type == COMPONENT_TYPES.BUTTON then
            print(string.format("  💫 Button: '%s' at (%d, %d) [%dx%d] - Blur: %.1f", component.text, component.x,
                component.y, component.width, component.height, component.blur))

        elseif component.type == COMPONENT_TYPES.CARD then
            print(string.format("  ✨ Card: '%s' at (%d, %d) [%dx%d] - Radius: %d", component.title, component.x,
                component.y, component.width, component.height, component.cornerRadius))

        elseif component.type == COMPONENT_TYPES.INPUT then
            print(string.format("  🔮 Input: '%s' at (%d, %d) [%dx%d] - %s", component.placeholder, component.x,
                component.y, component.width, component.height, component.isFocused and "Focused" or "Normal"))

        elseif component.type == COMPONENT_TYPES.MODAL then
            print(string.format("  🌟 Modal: '%s' at (%d, %d) [%dx%d] - %s", component.title, component.x,
                component.y, component.width, component.height, component.isVisible and "Visible" or "Hidden"))

        elseif component.type == COMPONENT_TYPES.NAVBAR then
            print(string.format("  🚀 Navbar at (%d, %d) [%dx%d] - %d items", component.x, component.y,
                component.width, component.height, #component.items))
        end
    end

    print(string.format("  ⚡ Active animations: %d", #self.animations))
end

-- Update function to be called in main loop
function GlassmorphismUI:update()
    self:updateAnimations()
end

-- Clean up resources
function GlassmorphismUI:cleanup()
    self.components = {}
    self.animations = {}
    self.hover_states = {}
end

return GlassmorphismUI
