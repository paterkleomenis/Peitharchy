#!/usr/bin/env bash
set -euo pipefail

if ! command -v rofi >/dev/null 2>&1; then
    notify-send "Power Profile" "rofi is not installed"
    exit 1
fi

if ! command -v powerprofilesctl >/dev/null 2>&1; then
    notify-send "Power Profile" "powerprofilesctl not found"
    exit 1
fi

CURRENT="$(powerprofilesctl get 2>/dev/null || echo "unknown")"

OPTIONS="$(powerprofilesctl list 2>/dev/null | awk '
{
    line=$0
    gsub(/^[*[:space:]]+/, "", line)
    if (line ~ /:$/) {
        sub(/:$/, "", line)
        if (line != "") print line
    }
}')"

if [[ -z "${OPTIONS}" ]]; then
    notify-send "Power Profile" "No selectable power profiles were found"
    exit 1
fi

CHOSEN="$(printf '%s\n' "$OPTIONS" | rofi -dmenu -i -p "Power Profile [$CURRENT]")"

case "${CHOSEN:-}" in
    performance|balanced|power-saver)
        "$HOME/.local/bin/toggle-performance.sh" "set_${CHOSEN//-/_}"
        ;;
    *)
        exit 0
        ;;
esac
