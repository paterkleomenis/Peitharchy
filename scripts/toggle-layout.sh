#!/bin/bash

# Get the currently active keyboard (the main one)
KEYBOARD=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .name')

if [ -z "$KEYBOARD" ]; then
    # Fallback to first keyboard if no main keyboard found
    KEYBOARD=$(hyprctl devices -j | jq -r '.keyboards[0].name')
fi

# Switch to next layout
hyprctl switchxkblayout "$KEYBOARD" next

# Get current layout info for notification (optional)
CURRENT_LAYOUT=$(hyprctl devices -j | jq -r ".keyboards[] | select(.name == \"$KEYBOARD\") | .active_keymap")

# Send notification (optional - requires notify-send)
if command -v notify-send >/dev/null 2>&1; then
    case "$CURRENT_LAYOUT" in
        *)
            notify-send "Keyboard Layout" "$CURRENT_LAYOUT" -t 1000 -i input-keyboard
            ;;
    esac
fi
