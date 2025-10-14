# Peitharchy

A modular Hyprland configuration for Arch Linux with custom Waybar, GTK theming, and productivity features.

## Overview

Peitharchy is a complete Hyprland desktop environment setup featuring:

- Modular Hyprland configuration split into logical files
- Custom Waybar with MPRIS media controls, clipboard management, and night light
- GTK 3.0/4.0 theming with Kora icon pack
- Greetd with tuigreet login manager
- Multi-language keyboard support
- Screenshot tools (hyprshot and flameshot)
- Night light integration via hyprsunset
- Multiple terminal options (kitty, ghostty)

## Features

### Window Manager
- **Hyprland** - Modern Wayland compositor with animations and blur effects
- **Modular Configuration** - Split into separate files for easy maintenance
  - `appearance.conf` - Visual settings, blur, shadows, animations
  - `autostart.conf` - Programs to launch on startup
  - `environment.conf` - Environment variables
  - `input.conf` - Keyboard, mouse, touchpad settings
  - `keybinds.conf` - Keyboard shortcuts
  - `monitors.conf` - Display configuration
  - `programs.conf` - Default applications
  - `window-rules.conf` - Window-specific rules

### Status Bar
- **Waybar** - Highly customizable status bar with:
  - Workspace indicators
  - Active window title
  - Clock with calendar
  - MPRIS media player controls
  - Volume control with WirePlumber
  - Keyboard layout switcher
  - Clipboard manager integration
  - Night light control
  - System tray
  - Notification center
  - Power menu

### Utilities
- **Clipboard Manager** - History and selection via rofi
- **Night Light** - Adjustable color temperature with hyprsunset
- **Screenshot Tools** - Region, window, and full-screen capture
- **Power Menu** - Shutdown, reboot, logout, lock, suspend options
- **Keyboard Layout Switcher** - Toggle between configured layouts

### Theming
- **GTK Theme** - HighContrastInverse dark theme with custom colors
- **Icons** - Kora icon pack
- **Cursor** - Breeze cursor theme
- **Font** - Inter font family

## Requirements

### Base System
- Arch Linux (or Arch-based distribution)
- Active internet connection
- sudo privileges

### Installed by Script

#### Official Repositories
- hyprland, hyprpaper, hypridle, hyprlock, hyprshot, hyprsunset
- waybar, rofi, cliphist, wl-clipboard, libnotify
- polkit-gnome, xdg-desktop-portal-hyprland, xdg-desktop-portal-gtk
- swaync, playerctl, jq, grim, slurp
- nautilus, network-manager-applet, blueman
- gnome-keyring, libsecret, polkit, gcr
- greetd, greetd-tuigreet, flameshot
- wireplumber, pavucontrol, alsa-utils
- pipewire, pipewire-alsa, pipewire-pulse, pipewire-jack
- kdeconnect
- kitty, neovim, nano
- ttf-jetbrains-mono-nerd, inter-font
- noto-fonts, noto-fonts-cjk, noto-fonts-emoji
- gtk3, gtk4, nwg-look, gnome-themes-extra, dconf
- flatpak

#### AUR (via paru) - Optional
- paru (AUR helper)
- xcursor-breeze (cursor theme - falls back to system default if unavailable)
- ghostty (terminal - kitty is used if unavailable)

**Note:** If AUR is unavailable, the installation will continue without these packages.

#### Flatpak
- MissionCenter (system monitor)

## Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd Peitharchy
```

2. (Optional) If you have mirror issues, fix them first:
```bash
chmod +x fix-mirrors.sh
./fix-mirrors.sh
```

3. Make the installation script executable:
```bash
chmod +x install.sh
```

4. Run the installation script:
```bash
./install.sh
```

The script will:
- Update your system
- Install all required packages from official repositories
- Install paru AUR helper
- Install AUR packages
- Set up Flatpak and install MissionCenter
- Install Kora icon theme
- Create necessary directories
- Copy all configuration files to appropriate locations
- Ask about GTK theme installation (keeps custom themes if you decline)
- Configure GTK themes and settings
- Set up greetd login manager
- Add user to required groups
- Create backups of existing configurations

4. Reboot your system:
```bash
reboot
```

5. At the login screen (tuigreet), select Hyprland and log in

## Configuration Locations

After installation, configurations are located at:

- **Hyprland**: `~/.config/hypr/`
- **Waybar**: `~/.config/waybar/`
- **Rofi**: `~/.config/rofi/`
- **Scripts**: `~/.local/bin/`
- **GTK**: `~/.config/gtk-3.0/` and `~/.config/gtk-4.0/`
- **Icons**: `~/.local/share/icons/`
- **Wallpapers**: `~/Pictures/wallpapers/`

## Key Bindings

### General
- `Super + Q` - Close active window
- `Alt + F4` - Close active window
- `Super + M` - Exit Hyprland
- `Super + V` - Toggle floating mode
- `Super + Space` - Open application launcher (rofi)
- `Super + J` - Toggle split direction
- `Super + P` - Toggle pseudo-tiling

### Applications
- `Ctrl + T` - Open terminal (kitty)
- `Super + T` - Open ghostty terminal
- `Super + E` - Open file manager
- `Super + F` - Open browser
- `Super + C` - Open clipboard manager
- `Ctrl + Shift + Esc` - Open task manager

### Window Management
- `Super + Arrow Keys` - Move focus between windows
- `Super + [1-9,0]` - Switch to workspace
- `Super + Shift + [1-9,0]` - Move window to workspace
- `Super + S` - Toggle scratchpad
- `Super + Shift + S` - Move window to scratchpad
- `Super + Mouse Wheel` - Cycle through workspaces
- `Super + Left Click` - Move window
- `Super + Right Click` - Resize window

### System
- `Super + L` - Lock screen
- `Super + I` - Toggle idle inhibitor
- `Super + N` - Toggle night light

### Screenshots
- `Print` - Region screenshot
- `Super + Print` - Flameshot GUI
- `Shift + Print` - Full screen screenshot
- `Ctrl + Print` - Active window screenshot

### Media
- `XF86AudioRaiseVolume` - Increase volume
- `XF86AudioLowerVolume` - Decrease volume
- `XF86AudioMute` - Mute/unmute audio
- `XF86AudioMicMute` - Mute/unmute microphone
- `XF86AudioPlay` - Play/pause media
- `XF86AudioNext` - Next track
- `XF86AudioPrev` - Previous track
- `XF86MonBrightnessUp` - Increase brightness (laptops)
- `XF86MonBrightnessDown` - Decrease brightness (laptops)

## Customization

### Changing Wallpapers
Place your wallpapers in `~/Pictures/wallpapers/` and edit `~/.config/hypr/hyprpaper.conf`

### Modifying Keybindings
Edit `~/.config/hypr/keybinds.conf`

### Adjusting Appearance
Edit `~/.config/hypr/appearance.conf` for blur, shadows, animations, gaps, and borders

### Waybar Customization
- Layout: `~/.config/waybar/config`
- Styling: `~/.config/waybar/style.css`

### GTK Theme Customization
- GTK 3.0: `~/.config/gtk-3.0/`
- GTK 4.0: `~/.config/gtk-4.0/`
- GUI tool: Run `nwg-look` for graphical theme selection

**Note:** If you have custom GTK themes, the install script will ask before overwriting them. You can choose to keep your custom themes during installation.

## Uninstallation

To remove Peitharchy and restore your system:

```bash
./uninstall.sh
```

This will remove all Peitharchy configurations. Backups created during installation will remain in your home directory.

## Troubleshooting

### AUR Unavailable
If you see "Cannot reach AUR (aur.archlinux.org)":

**This is OK** - the installation will continue without AUR packages. You'll still get:
- All Hyprland components
- Waybar and all utilities
- Kitty terminal (default)
- System default cursor

**To install AUR packages later:**
```bash
# Install paru
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# Install optional packages
paru -S xcursor-breeze ghostty
```

**Alternative solutions:**
- Wait and try again later (AUR sometimes has temporary issues)
- Use VPN or different network
- Install alternative packages from official repos:
  ```bash
  sudo pacman -S xcursor-themes  # Alternative cursors
  # Use kitty or alacritty instead of ghostty
  ```

### Mirror/Package Installation Issues
If you encounter errors like "failed retrieving file" or "The requested URL returned error: 503":

**Quick Fix:**
```bash
./fix-mirrors.sh
```

This script will:
- Update your Arch Linux keyring
- Install and configure reflector
- Backup your current mirrorlist
- Select the fastest mirrors for your region
- Test package installation

**Manual Fix:**
```bash
# Update keyring
sudo pacman -Sy archlinux-keyring

# Install reflector
sudo pacman -S reflector

# Update mirrors (choose fastest 20 worldwide)
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Sync databases
sudo pacman -Syy
```

### Waybar not appearing
```bash
killall waybar
waybar &
```

### Clipboard history not working
Start the clipboard daemon:
```bash
wl-paste --watch cliphist store &
```

### Night light not working
Check if hyprsunset is running:
```bash
pgrep hyprsunset
```

Toggle it:
```bash
~/.local/bin/hyprsunset.sh toggle
```

### Login screen not showing
Ensure greetd is enabled:
```bash
sudo systemctl enable greetd
sudo systemctl start greetd
```

### Screenshots not saving
Verify the screenshots directory exists:
```bash
mkdir -p ~/Pictures/Screenshots
```

## Project Structure

```
Peitharchy/
├── config                      # Waybar configuration
├── style.css                   # Waybar styling
├── install.sh                  # Installation script
├── uninstall.sh               # Uninstallation script
├── kora-1-7-2.tar.xz          # Kora icon theme archive
├── greetd/
│   └── config.toml            # Greetd login manager config
├── gtk-3.0/
│   ├── bookmarks              # File manager bookmarks
│   ├── colors.css             # Custom color definitions
│   ├── gtk.css                # GTK 3.0 styling
│   └── settings.ini           # GTK 3.0 settings
├── gtk-4.0/
│   ├── colors.css             # Custom color definitions
│   ├── gtk.css                # GTK 4.0 styling
│   └── settings.ini           # GTK 4.0 settings
├── hyprland/
│   ├── appearance.conf        # Visual settings
│   ├── autostart.conf         # Startup programs
│   ├── environment.conf       # Environment variables
│   ├── hypridle.conf          # Idle daemon config
│   ├── hyprland.conf          # Main config (sources others)
│   ├── hyprpaper.conf         # Wallpaper daemon config
│   ├── input.conf             # Input device settings
│   ├── keybinds.conf          # Keyboard shortcuts
│   ├── monitors.conf          # Display configuration
│   ├── programs.conf          # Default applications
│   └── window-rules.conf      # Window-specific rules
├── rofi/
│   └── config.rasi            # Rofi launcher config
├── scripts/
│   ├── clipboard_menu.sh      # Clipboard manager script
│   ├── hyprsunset.sh          # Night light control script
│   ├── power-menu.sh          # Power menu script
│   └── toggle-layout.sh       # Keyboard layout switcher
└── wallpapers/
    ├── black.png
    ├── picklerick.png
    └── windowidget.png
```

## Credits

- Hyprland - https://hyprland.org/
- Waybar - https://github.com/Alexays/Waybar
- Kora Icons - https://github.com/bikass/kora
- Rofi - https://github.com/davatorium/rofi

## License

This configuration is provided as-is for personal use and customization.