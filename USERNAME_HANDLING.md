# Username/Path Handling - Peitharchy

## Overview

The installation script automatically handles user-specific paths to ensure the configuration works for **any user** without manual editing.

---

## Implementation

### Source Files Use $HOME Variable

Instead of hardcoded usernames like `/home/pater/`, the source files now use the `$HOME` variable:

#### hyprland/hyprpaper.conf
```bash
# Before (hardcoded):
preload = /home/pater/Pictures/wallpapers/black.png

# Now (variable):
preload = $HOME/Pictures/wallpapers/black.png
```

#### gtk-3.0/bookmarks
```bash
# Before (hardcoded):
file:///home/pater/Downloads Downloads

# Now (variable):
file://$HOME/Downloads Downloads
```

---

## Automatic Replacement During Installation

The `install.sh` script automatically replaces `$HOME` with the actual home directory:

```bash
# Get current user's home directory
HOME_DIR="$HOME"

# Replace $HOME in hyprpaper.conf
sed -i "s|\$HOME|$HOME|g" ~/.config/hypr/hyprpaper.conf

# Replace $HOME in GTK bookmarks
sed -i "s|\$HOME|$HOME|g" ~/.config/gtk-3.0/bookmarks
```

---

## What Gets Updated

### 1. Hyprland Wallpaper Config
**File**: `~/.config/hypr/hyprpaper.conf`

**Before installation**:
```
preload = $HOME/Pictures/wallpapers/black.png
wallpaper = ,$HOME/Pictures/wallpapers/black.png
```

**After installation** (for user "john" for example):
```
preload = /home/john/Pictures/wallpapers/black.png
wallpaper = ,/home/john/Pictures/wallpapers/black.png
```

### 2. GTK File Manager Bookmarks
**File**: `~/.config/gtk-3.0/bookmarks`

**Before installation**:
```
file://$HOME/Downloads Downloads
file://$HOME/Documents Documents
file://$HOME/Pictures Pictures
```

**After installation** (for user "john" for example):
```
file:///home/john/Downloads Downloads
file:///home/john/Documents Documents
file:///home/john/Pictures Pictures
```

---

## Benefits

✅ **No Manual Editing Required**
- Users never need to edit config files manually
- Works on any system with any username

✅ **Portable**
- Source files can be shared/committed to git
- No user-specific information in source files

✅ **Automatic**
- Replacement happens during installation
- No user intervention needed

✅ **Reliable**
- Uses shell's built-in `$HOME` variable
- Works regardless of username length or characters

---

## Testing

You can verify the replacement works by checking the installed files:

```bash
# Check hyprpaper config
cat ~/.config/hypr/hyprpaper.conf | grep Pictures

# Check GTK bookmarks
cat ~/.config/gtk-3.0/bookmarks

# Both should show YOUR actual home directory, not $HOME or /home/pater/
```

---

## For Developers

If you add new config files that need user-specific paths:

1. **Use `$HOME` in source files**
   ```
   path = $HOME/some/directory
   ```

2. **Add replacement in install.sh**
   ```bash
   if [ -f ~/.config/yourapp/config ]; then
       sed -i "s|\$HOME|$HOME|g" ~/.config/yourapp/config
   fi
   ```

3. **Test with different usernames**
   ```bash
   # Create test user
   sudo useradd -m testuser
   
   # Switch and test
   sudo -u testuser ./install.sh
   ```

---

## Alternative: Using ~ Instead of $HOME

Note: We use `$HOME` instead of `~` because:

- `$HOME` is more explicit and clear in config files
- Some applications don't expand `~` properly
- `$HOME` works in all contexts (scripts, configs, etc.)
- Easier to search and replace programmatically

---

## Summary

The installation automatically converts:
- `$HOME` → `/home/YOUR_USERNAME/`

For the following files:
- ✅ `hyprland/hyprpaper.conf` - Wallpaper paths
- ✅ `gtk-3.0/bookmarks` - File manager bookmarks

**No manual editing required! Everything just works! ✨**
