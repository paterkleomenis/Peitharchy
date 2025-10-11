# GNOME Color Scheme - Dark Mode

## What It Does

The installation script automatically sets the GNOME/GTK color scheme preference to dark mode using:

```bash
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
```

## Why This Is Important

This setting ensures that:

1. **GTK4/libadwaita apps** respect dark mode
2. **Modern GNOME applications** use dark theme
3. **Applications that support dark mode detection** automatically switch
4. **System-wide consistency** for GTK applications

## Applications Affected

✅ **GNOME Apps** (Settings, Files, etc.)
✅ **GTK4 Applications** (modern apps using libadwaita)
✅ **Applications with dark mode support** (browsers, etc.)
✅ **File chooser dialogs** in GTK apps
✅ **Modern GTK widgets and controls**

## Verification

Check if dark mode is enabled:

```bash
gsettings get org.gnome.desktop.interface color-scheme
```

**Expected output**: `'prefer-dark'`

## Manual Control

### Enable Dark Mode

```bash
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
```

### Disable Dark Mode (use light theme)

```bash
gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
```

### Use System Default

```bash
gsettings set org.gnome.desktop.interface color-scheme "default"
```

## Difference from GTK_THEME

This is **different** from the `GTK_THEME` environment variable:

| Setting | What It Does |
|---------|--------------|
| `gsettings color-scheme` | Tells apps to prefer dark/light variants |
| `GTK_THEME` | Forces a specific theme (e.g., "Adwaita-dark") |
| `gtk-application-prefer-dark-theme` | GTK3 setting in settings.ini |

The installation script sets **all three** for maximum compatibility!

## Combined Dark Mode Setup

The script applies dark mode through multiple methods:

1. **gsettings** (this command)
   ```bash
   gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
   ```

2. **GTK3 settings.ini**
   ```ini
   gtk-application-prefer-dark-theme=1
   gtk-theme-name=Adwaita-dark
   ```

3. **GTK4 settings.ini**
   ```ini
   gtk-application-prefer-dark-theme=1
   ```

4. **Environment variable**
   ```bash
   env = GTK_THEME,Adwaita-dark
   ```

5. **Custom colors.css**
   - Custom dark color scheme for all GTK widgets

## Troubleshooting

### Apps not respecting dark mode

1. **Check the setting:**
   ```bash
   gsettings get org.gnome.desktop.interface color-scheme
   ```

2. **Re-apply if needed:**
   ```bash
   gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
   ```

3. **Restart the application** - Some apps need restart to pick up changes

4. **Check if app supports dark mode** - Not all apps have dark mode variants

### Reset to defaults

```bash
gsettings reset org.gnome.desktop.interface color-scheme
```

### List all GNOME interface settings

```bash
gsettings list-keys org.gnome.desktop.interface
```

## What Apps Use This

### Always Respect gsettings:
- GNOME Files (Nautilus)
- GNOME Settings
- GNOME Text Editor
- Most GTK4/libadwaita apps

### May Respect gsettings:
- Firefox (in some configurations)
- Chrome/Chromium (with GTK integration)
- Electron apps with GTK theme support

### Don't Use gsettings:
- Qt applications (use qt5ct/qt6ct instead)
- Electron apps without GTK support
- Apps that handle themes internally

## Additional Settings

Other useful GNOME dark mode settings:

```bash
# Icon theme
gsettings set org.gnome.desktop.interface icon-theme "kora"

# Cursor theme
gsettings set org.gnome.desktop.interface cursor-theme "breeze_cursors"

# GTK theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

# Font
gsettings set org.gnome.desktop.interface font-name "Inter 10"
```

These are NOT set by the script (handled by GTK configs instead), but you can use them if needed.

## Integration with Hyprland

The script sets this **during installation**, so when you:

1. Install with `./install.sh`
2. Reboot
3. Login to Hyprland

All GTK apps will already be in dark mode!

## Summary

✅ **Set automatically** during installation
✅ **System-wide dark mode** for GTK/GNOME apps
✅ **Works with** GTK theme settings and colors.css
✅ **No manual configuration** required
✅ **Persistent** across reboots and logins

**Result**: Complete dark mode coverage! 🌙

---

**Note**: This setting is stored in dconf database and persists across sessions. You only need to set it once (which the script does automatically).
