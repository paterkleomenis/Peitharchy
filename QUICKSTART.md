# Peitharchy Quick Start

## One-Line Install

```bash
./install.sh
```

Then **reboot** and select **Hyprland** from the login screen.

---

## What You Get

✅ **Hyprland** - Wayland compositor  
✅ **Waybar** - Top status bar  
✅ **Rofi** - App launcher  
✅ **Kora Icons** - Dark theme icons  
✅ **Kitty + Ghostty** - Terminal emulators  
✅ **GTK Dark Mode** - System-wide dark theme  
✅ **Wallpapers** - Pre-configured backgrounds  
✅ **All Scripts** - Ready to use  

---

## Essential Keybindings

| Action | Shortcut |
|--------|----------|
| **Launch Rofi** | `SUPER + R` |
| **Terminal** | `SUPER + T` |
| **File Manager** | `SUPER + E` |
| **Close Window** | `SUPER + Q` |
| **Lock Screen** | `SUPER + L` |
| **Switch Workspace** | `SUPER + [1-9]` |
| **Move Window** | `SUPER + SHIFT + [1-9]` |
| **Power Menu** | Click power icon in Waybar |

---

## Quick Config Paths

```
~/.config/hypr/          # Hyprland configs
~/.config/waybar/        # Waybar + scripts
~/.config/rofi/          # Rofi launcher
~/Pictures/wallpapers/   # Your wallpapers
```

---

## Change Wallpaper

Edit this file:
```bash
nano ~/.config/hypr/hyprpaper.conf
```

---

## Customize GTK Theme

```bash
nwg-look
```

---

## Troubleshooting

**Scripts not working?**
```bash
chmod +x ~/.config/waybar/scripts/*.sh
```

**Icons not showing?**
```bash
nwg-look  # Select "kora" as icon theme
```

**Dark theme not applied?**
```bash
cat ~/.config/gtk-3.0/settings.ini  # Verify settings
```

---

## Installed Terminals

- **Kitty** - Default (`kitty`)
- **Ghostty** - Alternative (`ghostty`)

---

## Useful Commands

```bash
# System monitor (Flatpak)
flatpak run io.missioncenter.MissionCenter

# Volume control
pavucontrol

# Bluetooth
blueman-manager

# File manager
nautilus

# Screenshot
flameshot gui
```

---

## Need Help?

📖 Full docs: `INSTALL.md`  
📋 Package list: `README.md`  
🌐 Hyprland Wiki: https://wiki.hyprland.org/

---

**Enjoy your Hyprland setup! 🚀**