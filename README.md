# SideMouseButtons

A tiny macOS utility to switch virtual desktops using your mouse side buttons (buttons 3 and 4).  
No windows, no Dock icon, optional menu bar icon.

## Features

- Switch desktops with mouse side buttons (3 = right, 4 = left)
- No windows, no Dock presence (LSUIElement)
- Hide/show menu bar icon
- Quit from menu bar

## Setup

1. Add `<key>LSUIElement</key><true/>` to Info.plist
2. Build & run in Xcode
3. Grant Accessibility permissions in System Settings → Privacy & Security → Accessibility

## Usage

- Press mouse side buttons to switch desktops
- Use the menu bar icon to hide it or quit the app

---

macOS 12+, Accessibility permission required.
