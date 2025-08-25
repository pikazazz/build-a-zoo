-- Gen Z UI Utilities and Animations
-- Helper functions for modern UI effects and gen Z styling
local UIUtils = {}

-- Color manipulation utilities
UIUtils.Colors = {
    -- Convert hex to RGB
    hexToRGB = function(hex)
        hex = hex:gsub("#", "")
        return {
            r = tonumber("0x" .. hex:sub(1, 2)),
            g = tonumber("0x" .. hex:sub(3, 4)),
            b = tonumber("0x" .. hex:sub(5, 6)),
            a = 255
        }
    end,

    -- Create color with alpha
    withAlpha = function(color, alpha)
        return {
            r = color.r,
            g = color.g,
            b = color.b,
            a = alpha
        }
    end,

    -- Blend two colors
    blend = function(color1, color2, ratio)
        ratio = math.max(0, math.min(1, ratio))
        return {
            r = math.floor(color1.r * (1 - ratio) + color2.r * ratio),
            g = math.floor(color1.g * (1 - ratio) + color2.g * ratio),
            b = math.floor(color1.b * (1 - ratio) + color2.b * ratio),
            a = math.floor(color1.a * (1 - ratio) + color2.a * ratio)
        }
    end,

    -- Gen Z inspired color palette
    genZPalette = {
        electricPurple = {
            r = 138,
            g = 43,
            b = 226,
            a = 255
        },
        neonCyan = {
            r = 0,
            g = 255,
            b = 255,
            a = 255
        },
        hotPink = {
            r = 255,
            g = 20,
            b = 147,
            a = 255
        },
        limeGreen = {
            r = 50,
            g = 205,
            b = 50,
            a = 255
        },
        goldenYellow = {
            r = 255,
            g = 215,
            b = 0,
            a = 255
        },
        deepOrange = {
            r = 255,
            g = 69,
            b = 0,
            a = 255
        }
    }
}

-- Animation easing functions
UIUtils.Easing = {
    linear = function(t)
        return t
    end,

    easeInQuad = function(t)
        return t * t
    end,

    easeOutQuad = function(t)
        return 1 - (1 - t) * (1 - t)
    end,

    easeInOutQuad = function(t)
        return t < 0.5 and 2 * t * t or 1 - math.pow(-2 * t + 2, 2) / 2
    end,

    easeInCubic = function(t)
        return t * t * t
    end,

    easeOutCubic = function(t)
        return 1 - math.pow(1 - t, 3)
    end,

    easeInOutCubic = function(t)
        return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
    end,

    -- Bounce effect (very gen Z)
    bounce = function(t)
        local n1 = 7.5625
        local d1 = 2.75

        if t < 1 / d1 then
            return n1 * t * t
        elseif t < 2 / d1 then
            t = t - 1.5 / d1
            return n1 * t * t + 0.75
        elseif t < 2.5 / d1 then
            t = t - 2.25 / d1
            return n1 * t * t + 0.9375
        else
            t = t - 2.625 / d1
            return n1 * t * t + 0.984375
        end
    end,

    -- Elastic effect (bouncy and modern)
    elastic = function(t)
        local c4 = (2 * math.pi) / 3

        if t == 0 then
            return 0
        end
        if t == 1 then
            return 1
        end

        return -math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * c4)
    end
}

-- Text formatting for gen Z style
UIUtils.Text = {
    -- Add emoji to text based on context
    addEmoji = function(text, context)
        context = context or "default"
        local emojiMap = {
            button = {"🚀", "✨", "💫", "🔥", "💎"},
            success = {"✅", "🎉", "🌟", "💚", "🎊"},
            error = {"❌", "🚨", "💀", "😤", "🔴"},
            info = {"ℹ️", "💡", "🤔", "👀", "📝"},
            warning = {"⚠️", "🟡", "😬", "👆", "📢"},
            default = {"😎", "🤙", "✌️", "🙌", "💯"}
        }

        local emojis = emojiMap[context] or emojiMap.default
        local emoji = emojis[math.random(#emojis)]
        return text .. " " .. emoji
    end,

    -- Convert text to gen Z speak
    genZify = function(text)
        local replacements = {
            ["good"] = "fire",
            ["great"] = "bussin",
            ["amazing"] = "slaps",
            ["bad"] = "mid",
            ["cool"] = "based",
            ["funny"] = "comedy",
            ["okay"] = "bet",
            ["yes"] = "fr",
            ["really"] = "lowkey",
            ["very"] = "literally"
        }

        local result = text:lower()
        for old, new in pairs(replacements) do
            result = result:gsub(old, new)
        end

        return result
    end,

    -- Create stylized text with effects
    createStyledText = function(text, style)
        style = style or {}
        return {
            text = text,
            font = style.font or "regular",
            size = style.size or 16,
            color = style.color or {
                r = 255,
                g = 255,
                b = 255,
                a = 255
            },
            shadow = style.shadow or false,
            glow = style.glow or false,
            weight = style.weight or "normal"
        }
    end
}

-- Glassmorphism effect utilities
UIUtils.Glass = {
    -- Create glass effect properties
    createEffect = function(blur, opacity, borderOpacity)
        return {
            blur = blur or 10,
            backgroundOpacity = opacity or 0.1,
            borderOpacity = borderOpacity or 0.2,
            backdrop = true
        }
    end,

    -- Generate glass border gradient
    createBorderGradient = function(color1, color2)
        return {
            type = "linear",
            direction = "45deg",
            stops = {{
                offset = 0,
                color = color1
            }, {
                offset = 1,
                color = color2
            }}
        }
    end,

    -- Apply glass effect to component
    applyGlass = function(component, intensity)
        intensity = intensity or "medium"

        local effects = {
            light = {
                blur = 5,
                opacity = 0.05,
                border = 0.1
            },
            medium = {
                blur = 10,
                opacity = 0.1,
                border = 0.2
            },
            heavy = {
                blur = 20,
                opacity = 0.15,
                border = 0.3
            }
        }

        local effect = effects[intensity] or effects.medium

        component.blur = effect.blur
        component.backgroundOpacity = effect.opacity
        component.borderOpacity = effect.border
        component.backdrop = true

        return component
    end
}

-- Layout utilities for responsive design
UIUtils.Layout = {
    -- Calculate responsive dimensions
    responsive = function(baseSize, screenSize, breakpoint)
        breakpoint = breakpoint or 1920
        local scale = math.min(screenSize / breakpoint, 1.5)
        return math.floor(baseSize * scale)
    end,

    -- Center element
    center = function(elementSize, containerSize)
        return (containerSize - elementSize) / 2
    end,

    -- Create grid layout
    createGrid = function(containerWidth, containerHeight, cols, rows, spacing)
        spacing = spacing or 10
        local cellWidth = (containerWidth - (cols - 1) * spacing) / cols
        local cellHeight = (containerHeight - (rows - 1) * spacing) / rows

        local grid = {}
        for row = 1, rows do
            for col = 1, cols do
                table.insert(grid, {
                    x = (col - 1) * (cellWidth + spacing),
                    y = (row - 1) * (cellHeight + spacing),
                    width = cellWidth,
                    height = cellHeight,
                    col = col,
                    row = row
                })
            end
        end

        return grid
    end
}

-- Modern interaction patterns
UIUtils.Interactions = {
    -- Create hover effect
    createHoverEffect = function(component, scale, duration)
        scale = scale or 1.05
        duration = duration or 0.2

        return {
            onEnter = function()
                component.isHovered = true
                -- Scale up animation would go here
            end,
            onLeave = function()
                component.isHovered = false
                -- Scale down animation would go here
            end,
            scale = scale,
            duration = duration
        }
    end,

    -- Create click ripple effect
    createRipple = function(x, y, maxRadius, duration)
        return {
            x = x,
            y = y,
            radius = 0,
            maxRadius = maxRadius or 50,
            duration = duration or 0.6,
            startTime = os.clock(),
            active = true
        }
    end,

    -- Create loading animation
    createLoader = function(type, color)
        type = type or "spinner"
        color = color or UIUtils.Colors.genZPalette.electricPurple

        return {
            type = type,
            color = color,
            progress = 0,
            speed = 2,
            active = true
        }
    end
}

-- Performance utilities
UIUtils.Performance = {
    -- FPS counter
    fps = {
        frames = 0,
        lastTime = os.clock(),
        current = 0,

        update = function(self)
            self.frames = self.frames + 1
            local currentTime = os.clock()

            if currentTime - self.lastTime >= 1.0 then
                self.current = self.frames
                self.frames = 0
                self.lastTime = currentTime
            end
        end,

        get = function(self)
            return self.current
        end
    },

    -- Object pooling for animations
    createPool = function(createFunc, resetFunc, initialSize)
        initialSize = initialSize or 10
        local pool = {
            objects = {},
            available = {},
            create = createFunc,
            reset = resetFunc
        }

        -- Pre-create objects
        for i = 1, initialSize do
            local obj = createFunc()
            table.insert(pool.objects, obj)
            table.insert(pool.available, obj)
        end

        pool.get = function()
            if #pool.available > 0 then
                return table.remove(pool.available)
            else
                local obj = pool.create()
                table.insert(pool.objects, obj)
                return obj
            end
        end

        pool.release = function(obj)
            pool.reset(obj)
            table.insert(pool.available, obj)
        end

        return pool
    end
}

-- Debug utilities
UIUtils.Debug = {
    -- Log with style
    log = function(message, level)
        level = level or "info"
        local prefixes = {
            info = "ℹ️",
            success = "✅",
            warning = "⚠️",
            error = "❌",
            debug = "🐛"
        }

        local prefix = prefixes[level] or "💬"
        print(prefix .. " " .. message)
    end,

    -- Show component bounds
    drawBounds = function(component)
        print(string.format("📦 Component bounds: x=%d, y=%d, w=%d, h=%d", component.x, component.y, component.width,
            component.height))
    end
}

return UIUtils
