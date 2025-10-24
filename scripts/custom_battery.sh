#!/usr/bin/env bash
set -euo pipefail

# Check if running on a laptop (battery present)
BAT_PATH="/sys/class/power_supply/BAT1"
if [[ ! -d "$BAT_PATH" ]]; then
    BAT_PATH="/sys/class/power_supply/BAT0"
    if [[ ! -d "$BAT_PATH" ]]; then
        # No battery found - not a laptop or no battery
        echo ""
        exit 0
    fi
fi

CAPACITY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")

# Get CPU mode
MODE_FILE="$HOME/.cache/cpu_mode"
MODE="unknown"
if [[ -f "$MODE_FILE" ]]; then
    MODE=$(cat "$MODE_FILE")
fi

# Choose icon based on capacity and status
if [[ "$STATUS" == "Charging" ]]; then
    ICON="󰂄"
    STATUS_TEXT="Charging"
elif [[ "$STATUS" == "Full" ]]; then
    ICON="󰁹"
    STATUS_TEXT="Full"
elif [[ "$STATUS" == "Not charging" ]]; then
    ICON="󰚥"
    STATUS_TEXT="Plugged In"
else
    # Discharging - show icon based on capacity
    if [[ $CAPACITY -ge 90 ]]; then
        ICON="󰁹"
    elif [[ $CAPACITY -ge 80 ]]; then
        ICON="󰂂"
    elif [[ $CAPACITY -ge 70 ]]; then
        ICON="󰂁"
    elif [[ $CAPACITY -ge 60 ]]; then
        ICON="󰂀"
    elif [[ $CAPACITY -ge 50 ]]; then
        ICON="󰁿"
    elif [[ $CAPACITY -ge 40 ]]; then
        ICON="󰁾"
    elif [[ $CAPACITY -ge 30 ]]; then
        ICON="󰁽"
    elif [[ $CAPACITY -ge 20 ]]; then
        ICON="󰁼"
    elif [[ $CAPACITY -ge 10 ]]; then
        ICON="󰁻"
    else
        ICON="󰁺"
    fi
    STATUS_TEXT="Discharging"
fi

# Create a simple visual indicator with Unicode blocks
BLOCKS=5
FILLED=$((CAPACITY * BLOCKS / 100))
if [[ $FILLED -eq 0 && $CAPACITY -gt 0 ]]; then
    FILLED=1
fi


# Output JSON for Waybar
echo "{\"text\": \"${ICON}\", \"tooltip\": \"Battery: ${CAPACITY}% (${STATUS_TEXT})\\nCPU Mode: ${MODE}\", \"class\": \"battery-${STATUS,,}\"}"
