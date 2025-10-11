# Pre-Installation Checklist

Before running `./install.sh`, make sure you have:

## System Requirements

- [ ] **Fresh or existing Arch Linux installation**
- [ ] **Internet connection** (for downloading packages)
- [ ] **Sudo privileges** (script will prompt for password)
- [ ] **At least 5GB free disk space** (for packages and dependencies)

## Pre-Installation Steps

### 1. Update Your System
```bash
sudo pacman -Syu
```

### 2. Ensure Base Development Tools
```bash
sudo pacman -S --needed base-devel git
```

### 3. Disable Conflicting Display Managers (if any)
Check if you have other display managers running:
```bash
systemctl list-units --type=service | grep -E 'gdm|sddm|lightdm|lxdm'
```

If any are active, the script will disable them for you, but you should be aware.

### 4. Backup Existing Configs (Optional but Recommended)
If you already have Hyprland or Waybar configs:
```bash
mkdir -p ~/config-backup
cp -r ~/.config/hypr ~/config-backup/
cp -r ~/.config/waybar ~/config-backup/
cp -r ~/.config/rofi ~/config-backup/
```

## What the Script Will Do

✅ Install ~60+ packages from official repos  
✅ Install paru (AUR helper)  
✅ Install AUR packages (ghostty, xcursor-breeze)  
✅ Install Flatpak and MissionCenter  
✅ Extract and install Kora icons  
✅ Copy all configuration files  
✅ Set up wallpapers with your username  
✅ Configure GTK dark theme  
✅ Enable greetd login manager  
✅ Add user to necessary groups  

## Estimated Time

- **First-time installation**: ~15-30 minutes (depending on internet speed)
- **Re-running script**: ~5-10 minutes (with cached packages)

## After Installation

1. **Reboot** your system
2. **Select Hyprland** from tuigreet login screen
3. **Enjoy** your new setup!

## Troubleshooting Before You Start

### If you get "permission denied"
```bash
chmod +x install.sh
```

### If you don't have git
```bash
sudo pacman -S git
```

### If you're not sure about your username
```bash
whoami
```
The script will automatically use your current username.

## Ready to Install?

```bash
./install.sh
```

## Need Help?

- Read `QUICKSTART.md` for basic usage after installation
- Read `INSTALL.md` for detailed information
- Read `README.md` for package list and manual installation

---

**Note**: The script is safe to re-run. It uses `--needed` flags to avoid reinstalling existing packages.