Peitharchy - Hyprland Setup for Arch Linux
==========================================

📦 Project Structure:
├── 📄 install.sh           ⭐ MAIN INSTALLATION SCRIPT (executable)
├── 📖 QUICKSTART.md         Quick reference guide
├── 📖 INSTALL.md            Detailed installation guide
├── 📖 README.md             Package list and manual commands
├── 📖 CHECKLIST.md          Pre-installation checklist
│
├── 🎨 Theme & Icons:
│   ├── kora-1-7-2.tar.xz   Icon theme archive
│   ├── config               Waybar configuration (JSON)
│   └── style.css            Waybar styling
│
├── 🖼️  wallpapers/          Wallpaper collection
│   ├── black.png
│   ├── picklerick.png
│   └── windowidget.png
│
├── ⚙️  hyprland/            Hyprland configurations
│   ├── hyprland.conf        Main config
│   ├── keybinds.conf        Keyboard shortcuts
│   ├── appearance.conf      Window styling
│   ├── autostart.conf       Startup apps
│   ├── programs.conf        Default programs
│   ├── hyprpaper.conf       Wallpaper config
│   ├── hypridle.conf        Idle settings
│   ├── environment.conf     Environment variables
│   ├── input.conf           Input devices
│   ├── monitors.conf        Monitor setup
│   └── window-rules.conf    Window rules
│
├── 🚀 scripts/              Utility scripts
│   ├── clipboard_menu.sh    Clipboard manager
│   ├── hyprsunset.sh        Night light
│   ├── power-menu.sh        Power options
│   └── toggle-layout.sh     Keyboard layout switcher
│
└── 🎯 rofi/                 Application launcher
    └── config.rasi          Rofi configuration

🎯 Quick Start:
   ./install.sh

📋 Features:
   ✓ Automatic package installation
   ✓ Dark theme (GTK + Kora icons)
   ✓ Dual terminals (kitty + ghostty)
   ✓ Dynamic username replacement
   ✓ Waybar with custom scripts
   ✓ Complete Hyprland setup
   ✓ Wallpapers pre-configured
   ✓ Greetd login manager

🔧 What Gets Installed:
   • 60+ packages from official repos
   • 2 AUR packages (ghostty, xcursor-breeze)
   • 1 Flatpak (MissionCenter)
   • Kora icon theme
   • All configurations

📍 Installation Targets:
   ~/.config/hypr/              → Hyprland configs
   ~/.config/waybar/            → Waybar + scripts
   ~/.config/rofi/              → Rofi launcher
   ~/.config/gtk-3.0/           → GTK3 dark theme
   ~/.config/gtk-4.0/           → GTK4 dark theme
   ~/.local/bin/                → User scripts
   ~/.local/share/icons/        → Kora icons
   ~/Pictures/wallpapers/       → Wallpapers

⏱️  Installation Time: ~15-30 minutes (first time)

🎮 Post-Install: Reboot → Select Hyprland → Enjoy!
