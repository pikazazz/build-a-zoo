-- Gen Z Theme System
-- Customizable themes for the glassmorphism UI components
local UIUtils = require("UI.UIUtils")

local ThemeSystem = {}
ThemeSystem.__index = ThemeSystem

-- Create new theme system
function ThemeSystem.new()
    local self = setmetatable({}, ThemeSystem)
    self.currentTheme = "genZ"
    self.themes = {}
    self:initializeThemes()
    return self
end

-- Initialize built-in themes
function ThemeSystem:initializeThemes()
    -- Gen Z Default Theme
    self.themes.genZ = {
        name = "Gen Z Vibes ✨",
        description = "Electric purple and neon cyan with glassmorphism",

        colors = {
            primary = {
                r = 138,
                g = 43,
                b = 226,
                a = 255
            }, -- Electric Purple
            secondary = {
                r = 0,
                g = 255,
                b = 255,
                a = 255
            }, -- Neon Cyan
            accent = {
                r = 255,
                g = 20,
                b = 147,
                a = 255
            }, -- Hot Pink
            background = {
                r = 16,
                g = 16,
                b = 24,
                a = 255
            }, -- Dark Background
            surface = {
                r = 255,
                g = 255,
                b = 255,
                a = 20
            }, -- Glass Surface
            text = {
                r = 255,
                g = 255,
                b = 255,
                a = 255
            }, -- White Text
            textSecondary = {
                r = 200,
                g = 200,
                b = 200,
                a = 255
            } -- Gray Text
        },

        effects = {
            blur = 12,
            borderOpacity = 0.2,
            shadowIntensity = 0.3,
            glowIntensity = 0.4
        },

        typography = {
            fontFamily = "Inter",
            headingSize = 24,
            bodySize = 16,
            smallSize = 14,
            lineHeight = 1.5
        },

        spacing = {
            xs = 4,
            sm = 8,
            md = 16,
            lg = 24,
            xl = 32,
            xxl = 48
        },

        borderRadius = {
            small = 8,
            medium = 12,
            large = 16,
            xlarge = 24
        }
    }

    -- Dark Aesthetic Theme
    self.themes.darkAesthetic = {
        name = "Dark Aesthetic 🖤",
        description = "Moody dark theme with purple accents",

        colors = {
            primary = {
                r = 88,
                g = 28,
                b = 135,
                a = 255
            }, -- Deep Purple
            secondary = {
                r = 30,
                g = 30,
                b = 46,
                a = 255
            }, -- Dark Gray
            accent = {
                r = 139,
                g = 69,
                b = 19,
                a = 255
            }, -- Saddle Brown
            background = {
                r = 8,
                g = 8,
                b = 12,
                a = 255
            }, -- Almost Black
            surface = {
                r = 255,
                g = 255,
                b = 255,
                a = 10
            }, -- Subtle Glass
            text = {
                r = 240,
                g = 240,
                b = 240,
                a = 255
            }, -- Off White
            textSecondary = {
                r = 160,
                g = 160,
                b = 160,
                a = 255
            } -- Medium Gray
        },

        effects = {
            blur = 8,
            borderOpacity = 0.15,
            shadowIntensity = 0.5,
            glowIntensity = 0.2
        },

        typography = {
            fontFamily = "JetBrains Mono",
            headingSize = 22,
            bodySize = 15,
            smallSize = 13,
            lineHeight = 1.4
        },

        spacing = {
            xs = 3,
            sm = 6,
            md = 12,
            lg = 18,
            xl = 24,
            xxl = 36
        },

        borderRadius = {
            small = 6,
            medium = 10,
            large = 14,
            xlarge = 20
        }
    }

    -- Cyber Neon Theme
    self.themes.cyberNeon = {
        name = "Cyber Neon 🌈",
        description = "Futuristic neon colors with high contrast",

        colors = {
            primary = {
                r = 0,
                g = 255,
                b = 157,
                a = 255
            }, -- Neon Green
            secondary = {
                r = 255,
                g = 0,
                b = 255,
                a = 255
            }, -- Magenta
            accent = {
                r = 0,
                g = 191,
                b = 255,
                a = 255
            }, -- Sky Blue
            background = {
                r = 0,
                g = 0,
                b = 0,
                a = 255
            }, -- Pure Black
            surface = {
                r = 0,
                g = 255,
                b = 157,
                a = 15
            }, -- Neon Glass
            text = {
                r = 255,
                g = 255,
                b = 255,
                a = 255
            }, -- White
            textSecondary = {
                r = 0,
                g = 255,
                b = 157,
                a = 200
            } -- Neon Green Text
        },

        effects = {
            blur = 15,
            borderOpacity = 0.4,
            shadowIntensity = 0.8,
            glowIntensity = 0.9
        },

        typography = {
            fontFamily = "Orbitron",
            headingSize = 26,
            bodySize = 16,
            smallSize = 14,
            lineHeight = 1.6
        },

        spacing = {
            xs = 4,
            sm = 8,
            md = 16,
            lg = 24,
            xl = 32,
            xxl = 48
        },

        borderRadius = {
            small = 4,
            medium = 8,
            large = 12,
            xlarge = 16
        }
    }

    -- Pastel Dreams Theme
    self.themes.pastelDreams = {
        name = "Pastel Dreams 🌸",
        description = "Soft pastel colors with dreamy effects",

        colors = {
            primary = {
                r = 255,
                g = 182,
                b = 193,
                a = 255
            }, -- Light Pink
            secondary = {
                r = 173,
                g = 216,
                b = 230,
                a = 255
            }, -- Light Blue
            accent = {
                r = 221,
                g = 160,
                b = 221,
                a = 255
            }, -- Plum
            background = {
                r = 248,
                g = 248,
                b = 255,
                a = 255
            }, -- Almost White
            surface = {
                r = 255,
                g = 255,
                b = 255,
                a = 40
            }, -- White Glass
            text = {
                r = 72,
                g = 61,
                b = 139,
                a = 255
            }, -- Dark Slate Blue
            textSecondary = {
                r = 119,
                g = 136,
                b = 153,
                a = 255
            } -- Light Slate Gray
        },

        effects = {
            blur = 20,
            borderOpacity = 0.3,
            shadowIntensity = 0.2,
            glowIntensity = 0.6
        },

        typography = {
            fontFamily = "Poppins",
            headingSize = 28,
            bodySize = 17,
            smallSize = 15,
            lineHeight = 1.7
        },

        spacing = {
            xs = 6,
            sm = 12,
            md = 20,
            lg = 28,
            xl = 36,
            xxl = 52
        },

        borderRadius = {
            small = 12,
            medium = 18,
            large = 24,
            xlarge = 32
        }
    }

    -- Retro Wave Theme
    self.themes.retroWave = {
        name = "Retro Wave 🌊",
        description = "80s inspired with neon gradients",

        colors = {
            primary = {
                r = 255,
                g = 0,
                b = 128,
                a = 255
            }, -- Neon Pink
            secondary = {
                r = 0,
                g = 255,
                b = 255,
                a = 255
            }, -- Cyan
            accent = {
                r = 255,
                g = 255,
                b = 0,
                a = 255
            }, -- Electric Yellow
            background = {
                r = 20,
                g = 0,
                b = 40,
                a = 255
            }, -- Dark Purple
            surface = {
                r = 255,
                g = 0,
                b = 128,
                a = 25
            }, -- Pink Glass
            text = {
                r = 255,
                g = 255,
                b = 255,
                a = 255
            }, -- White
            textSecondary = {
                r = 255,
                g = 0,
                b = 128,
                a = 200
            } -- Pink Text
        },

        effects = {
            blur = 10,
            borderOpacity = 0.5,
            shadowIntensity = 0.6,
            glowIntensity = 1.0
        },

        typography = {
            fontFamily = "Righteous",
            headingSize = 30,
            bodySize = 18,
            smallSize = 16,
            lineHeight = 1.4
        },

        spacing = {
            xs = 4,
            sm = 8,
            md = 16,
            lg = 24,
            xl = 32,
            xxl = 48
        },

        borderRadius = {
            small = 2,
            medium = 4,
            large = 8,
            xlarge = 12
        }
    }
end

-- Apply theme to component
function ThemeSystem:applyTheme(component, themeName)
    themeName = themeName or self.currentTheme
    local theme = self.themes[themeName]

    if not theme then
        print("⚠️ Theme '" .. themeName .. "' not found, using default")
        theme = self.themes.genZ
    end

    -- Apply colors
    if component.background then
        if component.background.color then
            component.background.color = theme.colors.surface
        end
    end

    -- Apply border colors
    if component.borderColor then
        component.borderColor = UIUtils.Colors.withAlpha(theme.colors.primary,
            math.floor(255 * theme.effects.borderOpacity))
    end

    -- Apply text colors
    if component.textStyle then
        component.textStyle.color = theme.colors.text
        component.textStyle.size = theme.typography.bodySize
    end

    -- Apply effects
    component.blur = theme.effects.blur
    component.cornerRadius = theme.borderRadius.medium

    -- Apply shadow
    if component.shadow then
        component.shadow.color = UIUtils.Colors.withAlpha(theme.colors.primary,
            math.floor(255 * theme.effects.shadowIntensity))
    end

    return component
end

-- Get current theme
function ThemeSystem:getCurrentTheme()
    return self.themes[self.currentTheme]
end

-- Set theme
function ThemeSystem:setTheme(themeName)
    if self.themes[themeName] then
        self.currentTheme = themeName
        print("🎨 Theme changed to: " .. self.themes[themeName].name)
        return true
    else
        print("❌ Theme '" .. themeName .. "' not found")
        return false
    end
end

-- List all available themes
function ThemeSystem:listThemes()
    print("🎨 Available Themes:")
    for key, theme in pairs(self.themes) do
        local indicator = (key == self.currentTheme) and "👉 " or "   "
        print(indicator .. theme.name .. " - " .. theme.description)
    end
end

-- Create custom theme
function ThemeSystem:createCustomTheme(name, themeData)
    self.themes[name] = themeData
    print("✨ Custom theme '" .. name .. "' created successfully!")
end

-- Get theme color
function ThemeSystem:getColor(colorName, themeName)
    themeName = themeName or self.currentTheme
    local theme = self.themes[themeName]

    if theme and theme.colors[colorName] then
        return theme.colors[colorName]
    else
        return {
            r = 255,
            g = 255,
            b = 255,
            a = 255
        } -- Default to white
    end
end

-- Generate gradient between theme colors
function ThemeSystem:createThemeGradient(color1Name, color2Name, themeName)
    themeName = themeName or self.currentTheme
    local theme = self.themes[themeName]

    if theme then
        local color1 = theme.colors[color1Name] or theme.colors.primary
        local color2 = theme.colors[color2Name] or theme.colors.secondary

        return {
            type = "linear",
            colors = {color1, color2},
            direction = "diagonal"
        }
    end

    return nil
end

-- Export theme as JSON-like table
function ThemeSystem:exportTheme(themeName)
    themeName = themeName or self.currentTheme
    local theme = self.themes[themeName]

    if theme then
        print("📤 Exporting theme: " .. theme.name)
        -- In a real implementation, this would serialize to JSON
        return theme
    end

    return nil
end

-- Import theme from table
function ThemeSystem:importTheme(name, themeData)
    if themeData and themeData.colors and themeData.effects then
        self.themes[name] = themeData
        print("📥 Theme '" .. name .. "' imported successfully!")
        return true
    else
        print("❌ Invalid theme data format")
        return false
    end
end

-- Generate random theme
function ThemeSystem:generateRandomTheme(name)
    local colors = UIUtils.Colors.genZPalette
    local colorKeys = {}
    for k, _ in pairs(colors) do
        table.insert(colorKeys, k)
    end

    local randomTheme = {
        name = name .. " 🎲",
        description = "Randomly generated theme",

        colors = {
            primary = colors[colorKeys[math.random(#colorKeys)]],
            secondary = colors[colorKeys[math.random(#colorKeys)]],
            accent = colors[colorKeys[math.random(#colorKeys)]],
            background = {
                r = math.random(10, 30),
                g = math.random(10, 30),
                b = math.random(10, 30),
                a = 255
            },
            surface = {
                r = 255,
                g = 255,
                b = 255,
                a = math.random(10, 30)
            },
            text = {
                r = 255,
                g = 255,
                b = 255,
                a = 255
            },
            textSecondary = {
                r = 200,
                g = 200,
                b = 200,
                a = 255
            }
        },

        effects = {
            blur = math.random(8, 20),
            borderOpacity = math.random(10, 40) / 100,
            shadowIntensity = math.random(20, 80) / 100,
            glowIntensity = math.random(20, 100) / 100
        },

        typography = {
            fontFamily = "Inter",
            headingSize = math.random(20, 32),
            bodySize = math.random(14, 20),
            smallSize = math.random(12, 16),
            lineHeight = 1.5
        },

        spacing = {
            xs = 4,
            sm = 8,
            md = 16,
            lg = 24,
            xl = 32,
            xxl = 48
        },

        borderRadius = {
            small = math.random(4, 12),
            medium = math.random(8, 20),
            large = math.random(12, 28),
            xlarge = math.random(16, 36)
        }
    }

    self.themes[name] = randomTheme
    print("🎲 Random theme '" .. name .. "' generated!")
    return randomTheme
end

return ThemeSystem
