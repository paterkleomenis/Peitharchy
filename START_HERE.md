# 🚀 Peitharchy - Hyprland Setup for Arch Linux

> A complete, ready-to-use Hyprland environment with dark theme, Kora icons, and all the bells and whistles.

## ⚡ Quick Start

```bash
./install.sh
```

Then **reboot** and select **Hyprland** from the login screen. That's it! 🎉

---

## 📚 Documentation

Choose your path:

| Document | What's Inside |
|----------|---------------|
| **[QUICKSTART.md](QUICKSTART.md)** | 🏃 Essential keybindings, commands, and tips |
| **[CHECKLIST.md](CHECKLIST.md)** | ✅ Pre-installation requirements and steps |
| **[INSTALL.md](INSTALL.md)** | 📖 Detailed installation guide and troubleshooting |
| **[README.md](README.md)** | 📋 Complete package list and manual commands |
| **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** | 🗂️ Visual project layout |

---

## 🎨 What You Get

### Core Features
- ✨ **Hyprland** - Beautiful Wayland compositor
- 🎯 **Waybar** - Sleek status bar with custom modules
- 🚀 **Rofi** - Fast application launcher
- 🌙 **Dark Theme** - GTK dark mode with Kora icons
- 🖼️ **Wallpapers** - Pre-configured backgrounds
- 📜 **Scripts** - Clipboard, night light, power menu, and more

### Applications
- 🖥️ **Terminals**: Kitty (default) + Ghostty
- 📁 **File Manager**: Nautilus
- 📊 **System Monitor**: MissionCenter (Flatpak)
- 📸 **Screenshots**: Flameshot + Hyprshot
- 🔗 **Phone Integration**: KDE Connect
- 🎵 **Media Control**: Built into Waybar

### Theme
- **Icons**: Kora (dark mode)
- **Cursor**: Breeze
- **Font**: Inter (UI) + JetBrains Mono Nerd (terminal)
- **GTK**: Adwaita-dark

---

## 📦 Installation Overview

The `install.sh` script will:

1. ✅ Update your Arch system
2. ✅ Install **60+ packages** from official repos
3. ✅ Install **paru** (AUR helper)
4. ✅ Install AUR packages (ghostty, xcursor-breeze)
5. ✅ Set up **Flatpak** and install MissionCenter
6. ✅ Extract and install **Kora icon theme**
7. ✅ Copy all **configuration files** (Hyprland, Waybar, Rofi)
8. ✅ Copy **GTK configs** (dark theme + custom colors.css)
9. ✅ Set up **wallpapers** with your username
10. ✅ Configure **GTK dark theme** with Kora icons
11. ✅ Enable **greetd** login manager
12. ✅ Add user to necessary groups

**Time Required**: ~15-30 minutes (depending on internet speed)

---

## 🎮 Essential Keybindings

| Action | Shortcut |
|--------|----------|
| Launch Rofi | `SUPER + R` |
| Open Terminal | `SUPER + T` |
| File Manager | `SUPER + E` |
| Close Window | `SUPER + Q` |
| Lock Screen | `SUPER + L` |
| Switch Workspace | `SUPER + [1-9]` |
| Move Window | `SUPER + SHIFT + [1-9]` |

> **See [QUICKSTART.md](QUICKSTART.md) for more keybindings**

---

## 📂 Project Structure

```
Peitharchy/
├── install.sh          ⭐ Run this to install everything
├── hyprland/           ⚙️  Hyprland configuration files
├── scripts/            🚀 Utility scripts (clipboard, night light, etc.)
├── rofi/               🎯 Rofi launcher config
├── wallpapers/         🖼️  Background images
├── gtk-3.0/            🎨 GTK3 dark theme + colors.css
├── gtk-4.0/            🎨 GTK4 dark theme + colors.css
├── config              📊 Waybar configuration
├── style.css           🎨 Waybar styling
└── kora-1-7-2.tar.xz  🎨 Kora icon theme
```

---

## 🔧 Requirements

- **OS**: Arch Linux (vanilla or existing installation)
- **Internet**: Required for downloading packages
- **Sudo**: You need sudo privileges
- **Space**: At least 5GB free disk space

---

## 🚦 Getting Started

### 1️⃣ Read the Checklist
```bash
cat CHECKLIST.md
```

### 2️⃣ Run the Installer
```bash
./install.sh
```

### 3️⃣ Reboot
```bash
reboot
```

### 4️⃣ Login to Hyprland
Select **Hyprland** from the tuigreet login screen.

### 5️⃣ Enjoy! 🎉
Everything should be configured and ready to use.

---

## 🎨 Customization

All configurations are in your `~/.config/` directory:

```bash
~/.config/hypr/      # Hyprland settings
~/.config/waybar/    # Status bar + scripts
~/.config/rofi/      # App launcher
~/.config/gtk-3.0/   # GTK3 theme + colors.css
~/.config/gtk-4.0/   # GTK4 theme + colors.css
~/.gtkrc-2.0         # GTK2 theme (older apps)
```

**Change GTK theme visually:**
```bash
nwg-look
```

**Change wallpaper:**
Edit `~/.config/hypr/hyprpaper.conf`

---

## 🆘 Troubleshooting

### Scripts not working?
```bash
chmod +x ~/.config/waybar/scripts/*.sh
```

### Icons not showing?
```bash
ls ~/.local/share/icons/ | grep kora
nwg-look  # Select "kora"
```

### Dark theme not applied?
```bash
cat ~/.config/gtk-3.0/settings.ini
nwg-look  # Reapply settings
```

> **For detailed troubleshooting, see [INSTALL.md](INSTALL.md)**

---

## 📝 Package List

### Official Repos (60+ packages)
Hyprland, Waybar, Rofi, SwayNC, Kitty, Nautilus, PipeWire, Flatpak, and many more...

### AUR Packages
- ghostty (terminal)
- xcursor-breeze (cursor theme)

### Flatpak
- MissionCenter (system monitor)

> **See [README.md](README.md) for the complete list**

---

## 🌟 Features in Detail

### Waybar Modules
- 🖥️ Workspace indicators
- 📝 Window title
- 🕐 Clock with calendar
- 🎵 Media player control (MPRIS)
- 🔊 Volume control
- ⌨️ Keyboard layout switcher
- 📋 Clipboard history
- 🌙 Night light toggle
- 🔔 Notification center
- ⚡ Power menu

### Custom Scripts
- **clipboard_menu.sh** - Browse clipboard history with Rofi
- **hyprsunset.sh** - Toggle night light, adjust temperature
- **power-menu.sh** - Shutdown, reboot, logout options
- **toggle-layout.sh** - Switch keyboard layouts

### Auto-Configured
- ✅ Username in all config files (no manual editing!)
- ✅ Wallpaper paths set correctly
- ✅ Scripts executable and in correct locations
- ✅ Dark theme applied system-wide (GTK2/3/4)
- ✅ Kora icons in all GTK apps
- ✅ Custom colors.css for consistent dark theme
- ✅ Breeze cursors configured
- ✅ PipeWire audio ready to use

---

## 🎯 Why Peitharchy?

- **Complete**: Everything you need in one package
- **Automated**: One script does it all
- **Modern**: Latest Hyprland with Wayland
- **Beautiful**: Dark theme with curated aesthetics
- **Functional**: All scripts and tools pre-configured
- **Documented**: Comprehensive guides included

---

## 📖 Learn More

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Documentation](https://github.com/Alexays/Waybar/wiki)
- [Arch Wiki](https://wiki.archlinux.org/)

---

## 🤝 Credits

- **Hyprland** - [Vaxry](https://github.com/hyprwm/Hyprland)
- **Kora Icons** - [bikass](https://github.com/bikass/kora)
- **Waybar** - [Alexays](https://github.com/Alexays/Waybar)

---

## 📜 License

Feel free to use, modify, and share this setup!

---

<div align="center">

**Ready to dive in?**

```bash
./install.sh
```

**Happy Hyprland-ing! 🚀✨**

</div>