# 🌟 Nexus UI Library

<div align="center">

![Version](https://img.shields.io/badge/version-1.5-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Roblox-red.svg)

**A modern, lightweight, and feature-rich UI library for Roblox**

[Features](#-features) • [Installation](#-installation) • [Documentation](#-documentation) • [Examples](#-examples)

</div>

---

## 📖 Introduction

**Nexus UI** is a powerful and elegant UI library designed specifically for Roblox game development. Built with performance and aesthetics in mind, Nexus provides developers with a comprehensive set of tools to create beautiful, responsive user interfaces with minimal effort.

### What is Nexus?

Nexus UI is a complete interface solution that offers:

- **🎨 Beautiful Design** - Modern, clean aesthetics with smooth animations
- **⚡ High Performance** - Optimized code with minimal resource usage
- **🛠️ Easy to Use** - Simple, intuitive API that's beginner-friendly
- **🎯 Feature-Rich** - Everything you need: buttons, toggles, dropdowns, inputs, and more
- **🎭 Customizable** - Multiple themes and extensive customization options
- **📱 Responsive** - Draggable, resizable, and minimizable windows

Whether you're creating a simple admin panel or a complex game hub, Nexus UI provides the foundation you need to build professional-grade interfaces quickly and efficiently.

---

## ✨ Features

### Core Components
- **Buttons** - Interactive buttons with click animations
- **Toggles** - Smooth switch-style toggles with state management
- **Dropdowns** - Single & multi-selection dropdowns with search
- **Inputs** - Text input fields with validation
- **Sections** - Collapsible sections for organized content
- **Paragraphs** - Formatted text blocks for information
- **Notifications** - Temporary pop-up notifications
- **Tabs** - Multi-tab interface for organized layouts

### Visual Features
- **3 Built-in Themes** - Dark, Gray, and Blue themes
- **Smooth Animations** - Polished transitions using TweenService
- **Loading Screen** - Customizable loader with progress bar
- **Draggable Windows** - Move windows anywhere on screen
- **Minimize/Maximize** - Collapsible interface for screen space
- **Auto-Scaling** - Responsive layouts that adapt to content

### Developer Features
- **Clean API** - Easy-to-understand function names and structure
- **Error Handling** - Built-in pcall protection for callbacks
- **Version Control** - Automatic version checking system
- **Player Info Tab** - Optional misc tab with player details
- **Discord Integration** - Built-in invite link component

---

## 📦 Installation

### Method 1: Load (Recommended)
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RaiWorks-Official/NexusUI/refs/heads/main/Init.lua"))()
```
---

## 📘 Documentation

### Getting Started

#### Creating a Window

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RaiWorks-Official/NexusUI/refs/heads/main/Loader.lua"))()

local Window = Library:CreateWindow({
    name = "My Script Hub",           -- Window title
    subtext = "v1.0",                 -- Subtitle (optional)
    theme = "Dark",                   -- Theme: "Dark", "Gray", "Blue"
    ver = "V1.5",                     -- Library version
    Misc = true,                      -- Show misc tab with player info
    Loader = true,                    -- Show loading screen
    Time = 2                          -- Loader duration in seconds
})
```

---

### Window Functions

#### Window:Notification
Display a temporary notification popup.

```lua
Window:Notification(title, text, duration)
```

**Parameters:**
- `title` (string) - Notification title
- `text` (string) - Notification message
- `duration` (number) - Display duration in seconds (default: 3)

**Example:**
```lua
Window:Notification("Success", "Settings saved!", 2)
```

---

#### Window:Tab
Create a new tab in the window.

```lua
local Tab = Window:Tab(name, index)
```

**Parameters:**
- `name` (string) - Tab name
- `index` (number) - Tab order position

**Returns:** Tab object

**Example:**
```lua
local MainTab = Window:Tab("Main", 1)
local SettingsTab = Window:Tab("Settings", 2)
```

---

### Tab Functions

#### Tab:Section
Create a collapsible section within a tab.

```lua
local Section = Tab:Section(name, description, index)
```

**Parameters:**
- `name` (string) - Section title
- `description` (string) - Section subtitle
- `index` (number) - Section order position

**Returns:** Section object

**Example:**
```lua
local ButtonSection = MainTab:Section("Buttons", "Click buttons below", 1)
```

---

#### Tab:Invite
Add a Discord invite component.

```lua
Tab:Invite(name, description, link)
```

**Parameters:**
- `name` (string) - Invite title
- `description` (string) - Invite description
- `link` (string) - Discord invite link

**Example:**
```lua
SettingsTab:Invite("Join Our Discord", "Get support and updates", "discord.gg/yourserver")
```

---

### Section Components

#### Section:Button
Create an interactive button.

```lua
Section:Button(text, callback)
```

**Parameters:**
- `text` (string) - Button text
- `callback` (function) - Function to execute on click

**Example:**
```lua
ButtonSection:Button("Click Me", function()
    print("Button was clicked!")
end)
```

---

#### Section:Toggle
Create a toggle switch.

```lua
Section:Toggle(text, default, callback)
```

**Parameters:**
- `text` (string) - Toggle label
- `default` (boolean) - Initial state (true/false)
- `callback` (function) - Function called with state parameter

**Example:**
```lua
Section:Toggle("Enable ESP", false, function(state)
    print("ESP is now:", state)
end)
```

---

#### Section:Dropdown
Create a dropdown menu (single or multi-select).

**Single Selection (Old Syntax):**
```lua
Section:Dropdown(text, options, callback)
```

**Parameters:**
- `text` (string) - Dropdown label
- `options` (table) - Array of option strings
- `callback` (function) - Function called with selected option

**Example:**
```lua
Section:Dropdown("Select Weapon", {"Sword", "Gun", "Bow"}, function(selected)
    print("Selected:", selected)
end)
```

**Single Selection (New Syntax):**
```lua
Section:Dropdown({
    text = "Select Mode",
    options = {"Easy", "Normal", "Hard"},
    callback = function(selected)
        print("Selected:", selected)
    end
})
```

**Multi Selection (NEW!):**
```lua
Section:Dropdown({
    text = "Select Items",
    options = {"Item 1", "Item 2", "Item 3"},
    multi = true,
    callback = function(selected)
        -- selected is a table of all selected items
        print("Selected items:", table.concat(selected, ", "))
    end
})
```

**Parameters:**
- `text` (string) - Dropdown label
- `options` (table) - Array of option strings
- `multi` (boolean) - Enable multi-selection (default: false)
- `callback` (function) - Function called with selection(s)

**Multi-select features:**
- Click to select/deselect multiple items
- Checkmarks (✓) appear next to selected items
- Shows count of selected items
- Returns table of all selected options
- Shows "(Multi)" label in dropdown title

---

#### Section:Input
Create a text input field.

```lua
Section:Input(text, placeholder, callback)
```

**Parameters:**
- `text` (string) - Input label
- `placeholder` (string) - Placeholder text
- `callback` (function) - Function called with entered text

**Example:**
```lua
Section:Input("Player Name", "Enter name...", function(text)
    print("Name entered:", text)
end)
```

---

#### Section:Paragraph
Create a formatted text block.

```lua
Section:Paragraph(title, content)
```

**Parameters:**
- `title` (string) - Paragraph title
- `content` (string) - Paragraph text (supports multiline)

**Example:**
```lua
Section:Paragraph("About", "This is a description of the script.\nIt supports multiple lines!")
```

---

## 💡 Examples

### Basic Script Template

```lua
-- Load Nexus UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RaiWorks-Official/NexusUI/refs/heads/main/Loader.lua"))()

-- Create Window
local Window = Library:CreateWindow({
    name = "My Script",
    subtext = "v1.0",
    theme = "Dark",
    ver = "V1.5",
    Misc = true,
    Loader = true,
    Time = 2
})

-- Create Main Tab
local MainTab = Window:Tab("Main", 1)

-- Create Button Section
local ButtonSection = MainTab:Section("Actions", "Quick actions", 1)

ButtonSection:Button("Print Hello", function()
    print("Hello World!")
    Window:Notification("Success", "Printed to console!", 2)
end)

-- Create Toggle Section
local ToggleSection = MainTab:Section("Toggles", "Enable features", 2)

ToggleSection:Toggle("Speed Boost", false, function(state)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = state and 50 or 16
end)

-- Create Settings Tab
local SettingsTab = Window:Tab("Settings", 2)

local ConfigSection = SettingsTab:Section("Configuration", "Adjust settings", 1)

ConfigSection:Dropdown("Theme", {"Dark", "Gray", "Blue"}, function(selected)
    print("Theme changed to:", selected)
end)

ConfigSection:Input("Custom Value", "Enter number...", function(text)
    local num = tonumber(text)
    if num then
        print("Value set to:", num)
    end
end)
```

### Advanced Multi-Dropdown Example

```lua
-- Create abilities section
local AbilitySection = MainTab:Section("Abilities", "Select your powers", 1)

-- Multi-select dropdown
AbilitySection:Dropdown({
    text = "Select Abilities",
    options = {"Speed", "Jump", "Fly", "Invisibility", "Teleport"},
    multi = true,
    callback = function(selected)
        print("Active abilities:", table.concat(selected, ", "))
        
        -- Apply abilities based on selection
        for _, ability in ipairs(selected) do
            if ability == "Speed" then
                -- Enable speed
            elseif ability == "Jump" then
                -- Enable jump boost
            end
        end
    end
})
```

### Player Teleport System

```lua
local TeleportTab = Window:Tab("Teleport", 3)
local TPSection = TeleportTab:Section("Locations", "Teleport to places", 1)

local locations = {
    Spawn = CFrame.new(0, 5, 0),
    Shop = CFrame.new(100, 5, 100),
    Arena = CFrame.new(-100, 5, -100)
}

for name, cframe in pairs(locations) do
    TPSection:Button("Teleport to " .. name, function()
        local char = game.Players.LocalPlayer.Character
        if char then
            char:SetPrimaryPartCFrame(cframe)
            Window:Notification("Teleported", "You've been teleported to " .. name, 2)
        end
    end)
end
```

---

## 🎨 Themes

Nexus UI includes 3 built-in themes:

### Dark Theme (Default)
- Background: `RGB(17, 17, 17)`
- Perfect for night-time use
- Reduces eye strain

### Gray Theme
- Background: `RGB(40, 40, 40)`
- Balanced and neutral
- Professional appearance

### Blue Theme
- Background: `RGB(20, 25, 35)`
- Cool color scheme
- Modern tech aesthetic

---

## 🔧 Customization

### Theme Colors

Each theme includes:
- `Background` - Main window background
- `Secondary` - Header and section backgrounds
- `Tertiary` - Component backgrounds
- `Accent` - Highlight color
- `Text` - Primary text color
- `SubText` - Secondary text color

---

## 📋 Best Practices

1. **Organize with Sections** - Group related components together
2. **Use Meaningful Names** - Clear labels improve usability
3. **Add Descriptions** - Help users understand each section
4. **Handle Errors** - Callbacks are pcall-protected, but validate input
5. **Test Thoroughly** - Check all components work as expected
6. **Keep It Simple** - Don't overwhelm users with too many options
7. **Use Notifications** - Provide feedback for user actions

---

## ⚠️ Requirements

- Roblox Executor with `HttpGet` and high UNC
- `setclipboard` function (for Discord invite feature)

---

## 🐛 Troubleshooting

### Window not appearing?
- Check console for errors
- Verify HttpGet is enabled
- Ensure version matches library version

### Components not working?
- Check callback functions for errors
- Verify all required parameters are provided
- Test with simple print statements first

### Theme not applying?
- Ensure theme name is exact: "Dark", "Gray", or "Blue"
- Check capitalization

---

## 📜 License

This project is licensed under the MIT License. You are free to use, modify, and distribute this library in your projects.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

---

## 🙏 Credits

**Nexus UI Library** - Created by Claude AI

Special thanks to to me for being lazy.

---

<div align="center">

**Made with Time for the community W Speed♥️**

⭐ Star this repository if you find it useful!

</div>
