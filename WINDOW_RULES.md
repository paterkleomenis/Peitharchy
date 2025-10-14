# Window Rules Documentation

## Overview

Peitharchy uses **percentage-based window sizing** to ensure floating windows work correctly across different screen resolutions. This means windows will scale appropriately whether you have a 1080p, 1440p, or 4K display.

## Why Percentage-Based?

**Problem with Fixed Sizes:**
```
windowrulev2 = size 1500 900, class:^(nautilus)$
```
- Works on 1920x1080: Takes 78% of screen width ✓
- Works on 2560x1440: Takes 58% of screen width (too small)
- Works on 3840x2160: Takes 39% of screen width (way too small)

**Solution with Percentages:**
```
windowrulev2 = size 70% 75%, class:^(nautilus)$
```
- Works on ANY resolution: Always takes 70% width, 75% height ✓

## Window Size Categories

### Small Utilities (20-30%)
- Calculator: 25% x 40%
- Color pickers: 20% x 25%
- Authentication dialogs: 30% x 20%
- Confirmation dialogs: 30% x 25%

**Use for:** Quick tools that don't need much space

### Medium Windows (40-60%)
- Audio controls (pavucontrol): 45% x 55%
- Bluetooth manager: 45% x 55%
- System settings: 50% x 60%
- Archive managers: 50% x 60%
- Task managers: 60% x 70%
- File choosers: 60% x 70%

**Use for:** Settings, managers, and medium content

### Large Windows (70-85%)
- File managers: 70% x 75%
- Communication apps (Discord/Telegram): 75% x 85%
- Terminals (ghostty): 80% x 80%
- Video players: 70% x 75%

**Use for:** Main work windows, content-heavy apps

### Picture-in-Picture (25%)
- PiP videos: 25% x 25%
- Positioned at 73% x 73% (bottom-right corner)

**Use for:** Background video while working

## Customizing Window Rules

### Basic Rule Structure

```conf
# 1. Make window float
windowrulev2 = float, class:^(app-name)$

# 2. Set size (percentage-based)
windowrulev2 = size 60% 70%, class:^(app-name)$

# 3. Position it (usually center)
windowrulev2 = center, class:^(app-name)$
```

### Finding App Class Names

**Method 1: Using hyprctl**
```bash
# Run your app, then:
hyprctl clients | grep class

# Or get detailed info:
hyprctl clients
```

**Method 2: Using hyprprop**
```bash
hyprctl clients | grep -A 10 "title:"
```

**Method 3: Check running windows**
```bash
hyprctl activewindow
```

### Common Rules Examples

#### Float a Specific App
```conf
windowrulev2 = float, class:^(my-app)$
windowrulev2 = size 50% 60%, class:^(my-app)$
windowrulev2 = center, class:^(my-app)$
```

#### Pin Window (Always on Top)
```conf
windowrulev2 = pin, class:^(my-app)$
```

#### Specific Workspace
```conf
windowrulev2 = workspace 2, class:^(my-app)$
```

#### Opacity Rules
```conf
windowrulev2 = opacity 0.9 0.9, class:^(my-app)$
```

#### Fullscreen on Start
```conf
windowrulev2 = fullscreen, class:^(my-app)$
```

#### Tile Instead of Float
```conf
windowrulev2 = tile, class:^(my-app)$
```

## Per-Resolution Customization

If you need different sizes for specific resolutions:

### Option 1: Create Resolution-Specific Configs

**For 1080p:**
```conf
# ~/.config/hypr/window-rules-1080p.conf
windowrulev2 = size 65% 70%, class:^(nautilus)$
```

**For 1440p:**
```conf
# ~/.config/hypr/window-rules-1440p.conf
windowrulev2 = size 70% 75%, class:^(nautilus)$
```

**For 4K:**
```conf
# ~/.config/hypr/window-rules-4k.conf
windowrulev2 = size 75% 80%, class:^(nautilus)$
```

Then in `hyprland.conf`:
```conf
# Source based on resolution
source = ~/.config/hypr/window-rules-1080p.conf
# OR
# source = ~/.config/hypr/window-rules-1440p.conf
```

### Option 2: Use Fixed Sizes for Specific Apps

If you prefer fixed sizes for certain apps:
```conf
# Calculator always 400x600 pixels
windowrulev2 = size 400 600, class:^(org.gnome.Calculator)$
```

## Advanced Rules

### Match by Title
```conf
windowrulev2 = float, title:^(Save As)$
windowrulev2 = size 60% 70%, title:^(Save As)$
windowrulev2 = center, title:^(Save As)$
```

### Match by Multiple Criteria
```conf
# Float Discord only when title contains "Voice"
windowrulev2 = float, class:^(discord)$, title:^(.*Voice.*)$
```

### Exclude Fullscreen Windows
```conf
windowrulev2 = float, class:^(my-app)$, fullscreen:0
```

### Initial Position
```conf
# Position window at specific percentage coordinates
windowrulev2 = move 10% 10%, class:^(my-app)$

# Bottom-right corner
windowrulev2 = move 70% 70%, class:^(my-app)$

# Top-right corner
windowrulev2 = move 70% 10%, class:^(my-app)$
```

## Testing Your Rules

### 1. Edit the config
```bash
nano ~/.config/hypr/window-rules.conf
```

### 2. Reload Hyprland
```bash
# Restart Hyprland
Super + Shift + R

# Or reload config
hyprctl reload
```

### 3. Test the app
- Open the application
- Check size and position
- Adjust percentages as needed

### 4. Debug issues
```bash
# Check if rule is applied
hyprctl clients | grep -A 20 "class: your-app"

# Check window properties
hyprctl activewindow
```

## Troubleshooting

### Window Doesn't Float

**Problem:** App doesn't follow float rule

**Solutions:**
1. Check app class name:
   ```bash
   hyprctl clients | grep class
   ```

2. Try title matching instead:
   ```conf
   windowrulev2 = float, title:^(App Name)$
   ```

3. Use broader matching:
   ```conf
   windowrulev2 = float, class:^(app).*$
   ```

### Window Too Large/Small

**Problem:** Percentage doesn't look right

**Solutions:**
1. Adjust percentages:
   ```conf
   # Too large? Reduce:
   windowrulev2 = size 50% 60%, class:^(app)$
   
   # Too small? Increase:
   windowrulev2 = size 80% 85%, class:^(app)$
   ```

2. Set minimum/maximum size:
   ```conf
   windowrulev2 = minsize 800 600, class:^(app)$
   windowrulev2 = maxsize 1920 1080, class:^(app)$
   ```

### Rule Not Applied

**Problem:** Changes don't take effect

**Solutions:**
1. Reload Hyprland:
   ```bash
   hyprctl reload
   ```

2. Check syntax:
   ```bash
   # View Hyprland logs
   journalctl -f -u hyprland
   ```

3. Rule order matters - more specific rules should come last

## Best Practices

1. **Use percentages** for most windows (scales with resolution)
2. **Use fixed sizes** only for dialogs that should be small on any screen
3. **Test on your resolution** to ensure comfortable sizes
4. **Keep backups** before making major changes
5. **Document custom rules** in comments
6. **Use descriptive names** in comments for clarity

## Example: Adding a New App

Let's say you want to float VS Code at 80% size:

```conf
# VS Code - large window for coding
windowrulev2 = float, class:^(code|Code|code-oss)$
windowrulev2 = size 80% 85%, class:^(code|Code|code-oss)$
windowrulev2 = center, class:^(code|Code|code-oss)$
```

Steps:
1. Find the class: `hyprctl clients | grep -i code`
2. Add rules to `~/.config/hypr/window-rules.conf`
3. Reload: `hyprctl reload`
4. Test: Open VS Code
5. Adjust if needed

## Reference

### All Size Properties
- `size WIDTHxHEIGHT` - Set window size
- `size WIDTH% HEIGHT%` - Percentage-based size
- `minsize WIDTHxHEIGHT` - Minimum size
- `maxsize WIDTHxHEIGHT` - Maximum size

### All Position Properties
- `center` - Center the window
- `move X Y` - Move to coordinates
- `move X% Y%` - Move to percentage position

### All Behavior Properties
- `float` - Make window floating
- `tile` - Force tiling
- `pin` - Always on top
- `fullscreen` - Start fullscreen
- `workspace N` - Send to workspace
- `monitor N` - Send to monitor

## Further Reading

- Official Hyprland Window Rules: https://wiki.hyprland.org/Configuring/Window-Rules/
- Hyprland Dispatcher List: https://wiki.hyprland.org/Configuring/Dispatchers/
- Regular Expressions Guide: https://regexr.com/

## Support

If you need help with window rules:
1. Check the app's class name with `hyprctl clients`
2. Test your regex at https://regex101.com/
3. Check Hyprland logs for errors
4. Ask in Hyprland Discord or GitHub discussions