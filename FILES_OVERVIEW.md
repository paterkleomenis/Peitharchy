# Complete Files Overview - Peitharchy

## 📄 Documentation Files (8)

| File | Purpose |
|------|---------|
| `START_HERE.md` | **Main entry point** - Complete overview and quick start |
| `QUICKSTART.md` | Essential keybindings and commands reference |
| `INSTALL.md` | Detailed installation guide with troubleshooting |
| `CHECKLIST.md` | Pre-installation requirements checklist |
| `README.md` | Complete package list and manual installation commands |
| `PROJECT_STRUCTURE.md` | Visual project layout and structure |
| `GTK_THEMING.md` | Complete GTK theming guide and customization |
| `INSTALLATION_FLOW.txt` | Visual step-by-step installation flow |

## 🚀 Installation

| File | Purpose |
|------|---------|
| `install.sh` | **Main installation script** (executable) |

## 🎨 Theme & Styling (3 + archive)

| File | Purpose |
|------|---------|
| `config` | Waybar configuration (JSON) |
| `style.css` | Waybar CSS styling |
| `kora-1-7-2.tar.xz` | Kora icon theme archive |

## 🎨 GTK Configuration (5 files in 2 directories)

### gtk-3.0/ (3 files)
| File | Purpose |
|------|---------|
| `settings.ini` | GTK3 theme settings (dark mode, Kora icons, Breeze cursors) |
| `colors.css` | Custom dark color scheme for GTK3 widgets |
| `bookmarks` | File manager bookmarks (auto-updated with username) |

### gtk-4.0/ (2 files)
| File | Purpose |
|------|---------|
| `settings.ini` | GTK4 theme settings (dark mode, Kora icons) |
| `colors.css` | Custom dark color scheme for GTK4/libadwaita widgets |

## ⚙️ Hyprland Configuration (11 files)

Located in: `hyprland/`

| File | Purpose |
|------|---------|
| `hyprland.conf` | Main Hyprland configuration file |
| `keybinds.conf` | All keyboard shortcuts and bindings |
| `appearance.conf` | Window appearance, borders, gaps, shadows |
| `autostart.conf` | Applications to start on login |
| `programs.conf` | Default applications (browser, terminal, etc.) |
| `hyprpaper.conf` | Wallpaper configuration (auto-updated with username) |
| `hypridle.conf` | Idle management settings |
| `environment.conf` | Environment variables |
| `input.conf` | Keyboard, mouse, touchpad settings |
| `monitors.conf` | Monitor configuration |
| `window-rules.conf` | Rules for specific windows/applications |

## 🚀 Utility Scripts (4 files)

Located in: `scripts/`

| File | Purpose |
|------|---------|
| `clipboard_menu.sh` | Clipboard history manager (Rofi integration) |
| `hyprsunset.sh` | Night light toggle and temperature control |
| `power-menu.sh` | Power options (shutdown, reboot, logout, lock) |
| `toggle-layout.sh` | Keyboard layout switcher |

## 🎯 Rofi Configuration (1 file)

Located in: `rofi/`

| File | Purpose |
|------|---------|
| `config.rasi` | Rofi application launcher configuration |

## 🖼️ Wallpapers (3 files)

Located in: `wallpapers/`

| File | Description |
|------|-------------|
| `black.png` | Default solid black wallpaper |
| `picklerick.png` | Pickle Rick themed wallpaper |
| `windowidget.png` | Window widget wallpaper |

---

## 📊 Statistics

- **Total Files**: 36
- **Directories**: 7
- **Documentation Pages**: 8
- **Configuration Files**: 17
- **Scripts**: 4 (executable)
- **Wallpapers**: 3
- **GTK Config Files**: 5

---

## 🎯 Key Features

✅ **Automatic Username Replacement**
- `hyprland/hyprpaper.conf` - Wallpaper paths
- `gtk-3.0/bookmarks` - File manager bookmarks

✅ **Dark Mode Everywhere**
- GTK2, GTK3, GTK4 configurations
- Custom colors.css for consistent theming
- Environment variables for Hyprland

✅ **Complete Documentation**
- 8 markdown files covering all aspects
- Quick reference guides
- Detailed troubleshooting

✅ **Ready-to-Use Scripts**
- All executable and properly placed
- Integrated with Waybar
- Available system-wide

---

## 📍 Installation Targets

When you run `./install.sh`, files are copied to:

```
~/.config/hypr/              ← hyprland/*
~/.config/waybar/            ← config, style.css
~/.config/waybar/scripts/    ← scripts/*
~/.config/rofi/              ← rofi/*
~/.config/gtk-3.0/           ← gtk-3.0/*
~/.config/gtk-4.0/           ← gtk-4.0/*
~/.gtkrc-2.0                 ← Generated GTK2 config
~/.local/bin/                ← scripts/*
~/.local/share/icons/        ← Extracted Kora theme
~/Pictures/wallpapers/       ← wallpapers/*
```

---

## 🎨 Theme Components

**Colors:**
- Background: #202326
- Content: #141618
- Text: #fcfcfc
- Border: #57595c
- Accent: #3daee9

**Fonts:**
- UI: Inter 10
- Terminal: JetBrains Mono Nerd Font

**Icons:** Kora (dark variants)

**Cursor:** Breeze (24px)

---

## 🚀 Quick Start

```bash
# 1. Review the checklist
cat CHECKLIST.md

# 2. Run the installer
./install.sh

# 3. Reboot
reboot

# 4. Select Hyprland from login screen

# 5. Enjoy! 🎉
```

---

**Everything you need for a complete Hyprland setup with dark theme! 🌙✨**
