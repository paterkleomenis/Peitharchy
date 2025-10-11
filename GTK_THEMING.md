# GTK Theming Guide - Peitharchy

## Overview

This setup includes comprehensive GTK theming that ensures dark mode is applied **everywhere** - across GTK2, GTK3, and GTK4 applications.

## What's Included

### GTK 3.0 Configuration
Located at: `gtk-3.0/`

- **settings.ini** - Main GTK3 settings
  - Dark theme preference enabled
  - Adwaita-dark theme
  - Kora icon theme
  - Breeze cursors
  - Inter font
  - Custom DPI and rendering settings

- **colors.css** - Custom color scheme
  - Dark background colors (#202326)
  - Dark content areas (#141618)
  - Light text (#fcfcfc)
  - Accent color (#3daee9)
  - Consistent styling for buttons, entries, selections, tooltips

- **bookmarks** - Nautilus/GTK file manager bookmarks
  - Downloads, Documents, Pictures
  - Updated automatically with your username

### GTK 4.0 Configuration
Located at: `gtk-4.0/`

- **settings.ini** - Main GTK4 settings
  - Dark theme preference
  - Kora icons
  - Breeze cursors
  - Inter font

- **colors.css** - Custom color scheme for GTK4/libadwaita
  - Same color palette as GTK3 for consistency
  - Updated selectors for GTK4 widgets
  - Libadwaita-compatible styling

### GTK 2.0 Configuration
Generated at: `~/.gtkrc-2.0`

- Legacy GTK2 support for older applications
- Matches GTK3/4 theme settings

## Color Scheme

The dark theme uses a carefully selected color palette:

```css
@define-color bg    #202326; /* window background */
@define-color base  #141618; /* content areas */
@define-color text  #fcfcfc; /* text color */
@define-color border #57595c; /* borders */
@define-color accent #3daee9; /* selections/focus */
```

## What Gets Styled

### GTK3 (colors.css)
- Windows and dialogs
- Text views and content areas
- Lists, tree views, icon views
- Notebooks and scrolled windows
- Header bars and title bars
- Buttons (normal, hover, focus, active states)
- Text entries and search bars
- Spin buttons and combo boxes
- Selections
- Tooltips

### GTK4 (colors.css)
- Windows and dialogs
- Text views with modern GTK4 structure
- List views, grid views, column views
- Notebooks and stacks
- Header bars
- Buttons with all states
- Entries and search entries
- Selections for modern GTK4 widgets
- Tooltips

## Installation

The installation script automatically:

1. Creates necessary directories:
   - `~/.config/gtk-3.0/`
   - `~/.config/gtk-4.0/`

2. Copies GTK configuration files:
   - `gtk-3.0/*` → `~/.config/gtk-3.0/`
   - `gtk-4.0/*` → `~/.config/gtk-4.0/`

3. Updates bookmarks with your actual username

4. Creates `~/.gtkrc-2.0` for GTK2 apps

5. Sets environment variables in Hyprland:
   ```bash
   env = GTK_THEME,Adwaita-dark
   env = XCURSOR_THEME,breeze_cursors
   env = XCURSOR_SIZE,24
   ```

## Applications Affected

✅ **GTK3 Applications:**
- Nautilus (file manager)
- GNOME System Monitor
- Most GNOME apps
- Many third-party GTK3 apps

✅ **GTK4 Applications:**
- Modern GNOME apps
- Newer GTK4 applications
- Apps using libadwaita

✅ **GTK2 Applications (Legacy):**
- Older applications still using GTK2
- Some proprietary software

## Customization

### Using nwg-look (GUI)
```bash
nwg-look
```

This tool lets you:
- Preview and change GTK themes
- Select icon themes (Kora is pre-selected)
- Adjust cursor themes
- Change fonts
- See changes in real-time

### Manual Editing

#### Change Theme Colors
Edit `~/.config/gtk-3.0/colors.css` or `~/.config/gtk-4.0/colors.css`:

```css
@define-color bg    #YOUR_BG_COLOR;
@define-color base  #YOUR_BASE_COLOR;
@define-color text  #YOUR_TEXT_COLOR;
@define-color accent #YOUR_ACCENT_COLOR;
```

#### Change Font
Edit `settings.ini` in gtk-3.0 or gtk-4.0:
```ini
gtk-font-name=YourFont 10
```

#### Change Icon Theme
Edit `settings.ini`:
```ini
gtk-icon-theme-name=your-icon-theme
```

#### Change Cursor
Edit `settings.ini`:
```ini
gtk-cursor-theme-name=your-cursor-theme
gtk-cursor-theme-size=24
```

## Troubleshooting

### Dark theme not applying to some apps

1. **Check if the app uses GTK:**
   ```bash
   ldd /usr/bin/app-name | grep gtk
   ```

2. **Force dark theme:**
   ```bash
   GTK_THEME=Adwaita-dark app-name
   ```

3. **Verify environment variables:**
   ```bash
   echo $GTK_THEME
   ```

### Icons not showing correctly

1. **Verify Kora is installed:**
   ```bash
   ls ~/.local/share/icons/ | grep kora
   ```

2. **Rebuild icon cache:**
   ```bash
   gtk-update-icon-cache ~/.local/share/icons/kora
   ```

3. **Check settings:**
   ```bash
   cat ~/.config/gtk-3.0/settings.ini | grep icon-theme
   ```

### Colors.css not applying

1. **Verify file exists:**
   ```bash
   ls -la ~/.config/gtk-3.0/colors.css
   ls -la ~/.config/gtk-4.0/colors.css
   ```

2. **Check for syntax errors:**
   The CSS should be valid. Look for missing semicolons or braces.

3. **Restart the application:**
   GTK apps may need to be restarted to pick up theme changes.

### GTK2 apps not themed

1. **Check .gtkrc-2.0:**
   ```bash
   cat ~/.gtkrc-2.0
   ```

2. **Some GTK2 apps may not fully support theming.**

## Testing Your Theme

Test with various GTK applications:

```bash
# GTK3 file chooser demo
gtk3-demo

# GTK4 demo
gtk4-demo

# Nautilus (file manager)
nautilus

# GNOME System Monitor
gnome-system-monitor
```

All should appear with:
- Dark background
- Kora icons
- Breeze cursor
- Consistent colors matching colors.css

## Advanced: Creating Your Own Color Scheme

1. Copy the existing colors.css:
   ```bash
   cp ~/.config/gtk-3.0/colors.css ~/.config/gtk-3.0/colors.css.backup
   ```

2. Edit the color definitions at the top of the file

3. Test with an application:
   ```bash
   nautilus
   ```

4. Iterate until satisfied

5. Copy to GTK4 for consistency:
   ```bash
   cp ~/.config/gtk-3.0/colors.css ~/.config/gtk-4.0/colors.css
   ```

## Resources

- [GTK3 CSS Documentation](https://docs.gtk.org/gtk3/css-properties.html)
- [GTK4 CSS Documentation](https://docs.gtk.org/gtk4/css-properties.html)
- [Kora Icons GitHub](https://github.com/bikass/kora)
- [Breeze Cursors](https://github.com/KDE/breeze)

## Summary

This GTK theming setup ensures:
- ✅ Consistent dark mode across all GTK versions
- ✅ Beautiful Kora icons everywhere
- ✅ Custom color scheme matching the Hyprland aesthetic
- ✅ Smooth Breeze cursors
- ✅ Proper font rendering
- ✅ Automatic username replacement in configs
- ✅ Easy customization via nwg-look or manual editing

Enjoy your beautiful, consistent dark theme! 🌙