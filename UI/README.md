# Gen Z Glassmorphism UI Components 🚀

A modern, gen Z-inspired UI library built in Lua featuring glassmorphism effects, smooth animations, and contemporary styling.

## 🎨 Features

- **Glassmorphism Effects**: Translucent backgrounds with blur effects
- **Gen Z Aesthetics**: Electric purple and neon cyan color scheme
- **Smooth Animations**: Easing functions and hover effects
- **Theme System**: Multiple customizable themes
- **Modern Components**: Buttons, cards, inputs, modals, and navigation
- **Responsive Design**: Adaptive layouts and sizing

## 📁 File Structure

```
UI/
├── GlassmorphismUI.lua    # Main UI component library
├── UIDemo.lua             # Demo and usage examples
├── UIUtils.lua            # Utility functions and helpers
├── ThemeSystem.lua        # Theme management system
└── README.md              # This file
```

## 🚀 Quick Start

```lua
-- Import the UI library
local GlassmorphismUI = require("UI.GlassmorphismUI")
local ThemeSystem = require("UI.ThemeSystem")

-- Create UI instance
local ui = GlassmorphismUI.new()
local themes = ThemeSystem.new()

-- Create a glassmorphism button
local button = ui:createButton(100, 100, 200, 60, "Click Me! ✨", function()
    print("Button clicked! 🎉")
end)

-- Apply theme
themes:applyTheme(button, "genZ")

-- Handle interactions
ui:handleMouseMove(150, 130)  -- Hover effect
ui:handleMouseClick(150, 130) -- Click action

-- Update animations
ui:update()

-- Render components
ui:render()
```

## 🎨 Available Themes

### 1. Gen Z Vibes ✨ (Default)
- **Primary**: Electric Purple (#8A2BE2)
- **Secondary**: Neon Cyan (#00FFFF)
- **Style**: Modern glassmorphism with vibrant colors

### 2. Dark Aesthetic 🖤
- **Primary**: Deep Purple
- **Secondary**: Dark Gray
- **Style**: Moody and minimalistic

### 3. Cyber Neon 🌈
- **Primary**: Neon Green
- **Secondary**: Magenta
- **Style**: Futuristic high-contrast design

### 4. Pastel Dreams 🌸
- **Primary**: Light Pink
- **Secondary**: Light Blue
- **Style**: Soft and dreamy pastels

### 5. Retro Wave 🌊
- **Primary**: Neon Pink
- **Secondary**: Cyan
- **Style**: 80s inspired synthwave

## 🧩 Components

### Button
```lua
local button = ui:createButton(x, y, width, height, text, callback)
```

### Card
```lua
local card = ui:createCard(x, y, width, height, title, content)
```

### Input Field
```lua
local input = ui:createInput(x, y, width, height, placeholder)
```

### Modal
```lua
local modal = ui:createModal(width, height, title, content)
```

### Navigation Bar
```lua
local navbar = ui:createNavbar(width, height, items)
```

## 🎭 Theme Usage

```lua
local themes = ThemeSystem.new()

-- List available themes
themes:listThemes()

-- Change theme
themes:setTheme("cyberNeon")

-- Apply theme to component
themes:applyTheme(button, "darkAesthetic")

-- Create custom theme
themes:createCustomTheme("myTheme", {
    name = "My Custom Theme",
    colors = {
        primary = {r = 255, g = 100, b = 50, a = 255},
        secondary = {r = 50, g = 100, b = 255, a = 255}
        -- ... more colors
    }
    -- ... other theme properties
})

-- Generate random theme
themes:generateRandomTheme("randomTheme")
```

## 🛠 Utilities

### Color Manipulation
```lua
local UIUtils = require("UI.UIUtils")

-- Convert hex to RGB
local color = UIUtils.Colors.hexToRGB("#FF6B35")

-- Blend colors
local blended = UIUtils.Colors.blend(color1, color2, 0.5)

-- Add alpha
local transparent = UIUtils.Colors.withAlpha(color, 128)
```

### Animations
```lua
-- Apply easing
local easedValue = UIUtils.Easing.easeOutCubic(progress)

-- Bounce effect
local bounceValue = UIUtils.Easing.bounce(progress)
```

### Layout
```lua
-- Create responsive grid
local grid = UIUtils.Layout.createGrid(800, 600, 3, 2, 10)

-- Center element
local centerX = UIUtils.Layout.center(elementWidth, containerWidth)
```

## 🎯 Advanced Usage

### Custom Animations
```lua
-- Animate component property
ui:animateComponent(button, "blur", 20, 0.5)

-- Create hover effects
local hoverEffect = UIUtils.Interactions.createHoverEffect(button, 1.1, 0.3)
```

### Glass Effects
```lua
-- Apply glass effect
UIUtils.Glass.applyGlass(component, "heavy")

-- Create glass border
local borderGradient = UIUtils.Glass.createBorderGradient(color1, color2)
```

### Performance
```lua
-- Monitor FPS
UIUtils.Performance.fps:update()
local currentFPS = UIUtils.Performance.fps:get()

-- Object pooling
local pool = UIUtils.Performance.createPool(createFunc, resetFunc, 20)
```

## 🎮 Running the Demo

```lua
-- Run the interactive demo
local UIDemo = require("UI.UIDemo")
UIDemo.run()
```

This will create a complete interface showcasing all components with gen Z styling and glassmorphism effects.

## 🎨 Color Palette

The default gen Z theme uses these carefully selected colors:

- **Electric Purple**: `#8A2BE2` - Primary brand color
- **Neon Cyan**: `#00FFFF` - Secondary/accent color
- **Hot Pink**: `#FF1493` - Additional accent
- **Deep Space**: `#101018` - Background
- **Glass White**: `#FFFFFF` (with transparency) - Surface elements

## 🚀 Performance Tips

1. **Use Object Pooling**: For frequently created/destroyed elements
2. **Limit Animations**: Don't animate too many properties simultaneously
3. **Batch Updates**: Group component updates together
4. **Optimize Blur**: Lower blur values for better performance

## 🤝 Contributing

Feel free to extend this UI library with:
- New component types
- Additional themes
- Animation improvements
- Performance optimizations
- Accessibility features

## 📝 License

This UI library is open source and available for modification and distribution.

---

Made with 💜 for the gen Z coding community. Keep it fresh, keep it modern! ✨
