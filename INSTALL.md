# Peitharchy Installation Guide

Complete Hyprland setup for Arch Linux with dark theme, Kora icons, and all configurations.

## Quick Install

For a fresh Arch Linux installation, simply run:

```bash
./install.sh
```

Then reboot your system and select Hyprland from the login screen.

## What Gets Installed

### Core Components
- **Hyprland** - Dynamic tiling Wayland compositor
- **Waybar** - Customizable status bar
- **Rofi** - Application launcher
- **SwayNC** - Notification center
- **Hyprpaper** - Wallpaper manager
- **Hypridle** - Idle management
- **Hyprlock** - Screen locker

### Terminals
- **Kitty** - Default terminal
- **Ghostty** - Alternative terminal (AUR)

### Applications
- **Nautilus** - File manager
- **MissionCenter** - System monitor (Flatpak)
- **Flameshot** - Screenshot tool
- **KDE Connect** - Phone integration

### Theme & Icons
- **Kora Icons** - Beautiful icon theme (installed automatically)
- **Breeze Cursors** - Mouse cursor theme
- **Adwaita Dark** - GTK dark theme
- **Inter Font** - UI font
- **JetBrains Mono Nerd Font** - Terminal font

### System
- **PipeWire** - Audio server
- **Polkit GNOME** - Authentication agent
- **GNOME Keyring** - Password management
- **Greetd + TuiGreet** - Login manager

## Installation Details

The script automatically:

1. **Updates your system**
2. **Installs all packages** from official repos
3. **Installs paru** (AUR helper) if needed
4. **Installs AUR packages** (xcursor-breeze, ghostty)
5. **Sets up Flatpak** and installs MissionCenter
6. **Extracts Kora icons** to ~/.local/share/icons/
7. **Copies configurations**:
   - Hyprland configs → ~/.config/hypr/
   - Waybar config & styles → ~/.config/waybar/
   - Rofi config → ~/.config/rofi/
   - Scripts → ~/.local/bin/ and ~/.config/waybar/scripts/
   - GNOME color scheme → prefer-dark (via gsettings)
8. **Copies wallpapers** to ~/Pictures/wallpapers/
9. **Configures GTK theme** (dark mode + Kora icons)
10. **Updates paths** with your actual username
11. **Enables greetd** and configures tuigreet
12. **Adds user to necessary groups** (input, video, audio)

## Post-Installation

After running the script and rebooting:

1. You'll see the **TuiGreet** login screen
2. Enter your credentials
3. Select **Hyprland** as your session
4. Your system will start with:
   - Dark theme enabled
   - Kora icons applied
   - Waybar at the top
   - All keybindings configured
   - Scripts functional
   - GNOME/GTK dark mode enabled

## Customization

### GTK Theme
Use `nwg-look` to further customize GTK themes:
```bash
nwg-look
```

### Wallpapers
Your wallpapers are in `~/Pictures/wallpapers/`

To change the wallpaper, edit:
```bash
~/.config/hypr/hyprpaper.conf
```

### Waybar
Edit the bar configuration:
```bash
~/.config/waybar/config
~/.config/waybar/style.css
```

### Rofi
Customize the launcher:
```bash
~/.config/rofi/config.rasi
```

### Hyprland
Main configuration files in `~/.config/hypr/`:
- `hyprland.conf` - Main config
- `keybinds.conf` - Keyboard shortcuts
- `appearance.conf` - Window appearance
- `autostart.conf` - Startup applications
- `programs.conf` - Default applications

## Key Bindings

Check `~/.config/hypr/keybinds.conf` for all keybindings.

Common shortcuts:
- `SUPER + Q` - Close window
- `SUPER + T` - Terminal
- `SUPER + E` - File manager
- `SUPER + R` - Rofi launcher
- `SUPER + L` - Lock screen
- `SUPER + [1-9]` - Switch workspace
- `SUPER + SHIFT + [1-9]` - Move window to workspace

## Scripts

The following scripts are available:
- `clipboard_menu.sh` - Clipboard history manager
- `hyprsunset.sh` - Night light toggle
- `power-menu.sh` - Power options menu
- `toggle-layout.sh` - Keyboard layout switcher

## Troubleshooting

### Waybar scripts not working
Ensure scripts are executable:
```bash
chmod +x ~/.config/waybar/scripts/*.sh
```

### Icons not showing
Verify Kora is installed:
```bash
ls ~/.local/share/icons/ | grep kora
```

### Dark theme not applied
Check GTK settings:
```bash
cat ~/.config/gtk-3.0/settings.ini
```

Check GNOME color scheme:
```bash
gsettings get org.gnome.desktop.interface color-scheme
```

If needed, manually set it:
```bash
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
```

Run `nwg-look` to reapply settings.

### Wallpaper not loading
Check the path in `~/.config/hypr/hyprpaper.conf` matches your username and wallpaper exists.

## Manual Installation

If you prefer manual installation, follow the commands in `README.md`.

## Support

For issues or questions, refer to:
- [Hyprland Wiki](https://wiki.hyprland.org/)
- Your configuration files in `~/.config/`

## Credits

- **Hyprland** - Vaxry and contributors
- **Kora Icons** - https://github.com/bikass/kora
- **Waybar** - Alexays and contributors