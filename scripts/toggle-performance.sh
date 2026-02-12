#!/usr/bin/env bash
# Peitharchy Power Manager (power-profiles-daemon backend)
set -euo pipefail

# Use SUDO_USER's home if running under sudo, otherwise use HOME
if [[ -n "${SUDO_USER:-}" ]]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME="$HOME"
fi

MODE_FILE="$USER_HOME/.cache/cpu_mode"
mkdir -p "$(dirname "$MODE_FILE")"

send_notification() {
    local title="$1"
    local message="$2"

    if [[ -n "${SUDO_USER:-}" ]]; then
        local user_id
        user_id=$(id -u "$SUDO_USER")
        sudo -u "$SUDO_USER" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${user_id}/bus" \
            notify-send "$title" "$message" 2>/dev/null || true
    else
        notify-send "$title" "$message" 2>/dev/null || true
    fi
}

ppd_available() {
    command -v powerprofilesctl >/dev/null 2>&1
}

get_profile() {
    powerprofilesctl get 2>/dev/null || true
}

set_profile() {
    local profile="$1"
    powerprofilesctl set "$profile"
}

available_profiles() {
    powerprofilesctl list 2>/dev/null | awk '
    {
        line=$0
        gsub(/^[*[:space:]]+/, "", line)
        if (line ~ /:$/) {
            sub(/:$/, "", line)
            if (line != "") print line
        }
    }'
}

try_set_profile() {
    local profile="$1"
    if set_profile "$profile"; then
        return 0
    fi
    send_notification "Power Mode" "Profile '$profile' is not available right now"
    return 1
}

# Keep old command names for compatibility with existing keybinds/UI.
COMMAND="${1:-toggle}"

if ! ppd_available; then
    send_notification "Power Mode" "powerprofilesctl not found. Install power-profiles-daemon."
    exit 1
fi

case "$COMMAND" in
    "toggle")
        CURRENT_PROFILE="$(get_profile)"
        mapfile -t PROFILES < <(available_profiles)
        if [[ ${#PROFILES[@]} -eq 0 ]]; then
            exit 0
        fi

        NEXT_PROFILE="${PROFILES[0]}"
        for i in "${!PROFILES[@]}"; do
            if [[ "${PROFILES[$i]}" == "$CURRENT_PROFILE" ]]; then
                NEXT_PROFILE="${PROFILES[$(((i + 1) % ${#PROFILES[@]}))]}"
                break
            fi
        done

        # No popup noise on unavailable targets during left-click cycling.
        set_profile "$NEXT_PROFILE" >/dev/null 2>&1 || exit 0

        if [[ "$NEXT_PROFILE" == "performance" ]]; then
            hyprctl keyword misc:vfr false || true
        else
            hyprctl keyword misc:vfr true || true
            if [[ "$NEXT_PROFILE" == "power-saver" ]] && command -v bluetoothctl >/dev/null 2>&1; then
                if [[ -z "$(bluetoothctl devices Connected)" ]]; then
                    bluetoothctl power off || true
                fi
            fi
        fi
        echo "$NEXT_PROFILE" > "$MODE_FILE"
        send_notification "Power Mode" "Switched to $NEXT_PROFILE"
        ;;

    "status")
        get_profile
        ;;

    "set_performance")
        try_set_profile performance || exit 1
        hyprctl keyword misc:vfr false || true
        echo "performance" > "$MODE_FILE"
        send_notification "Power Mode" "Switched to performance"
        ;;

    "set_balanced")
        try_set_profile balanced || exit 1
        hyprctl keyword misc:vfr true || true
        echo "balanced" > "$MODE_FILE"
        send_notification "Power Mode" "Switched to balanced"
        ;;

    "set_powersave"|"set_power_saver")
        try_set_profile power-saver || exit 1
        hyprctl keyword misc:vfr true || true
        echo "power-saver" > "$MODE_FILE"
        send_notification "Power Mode" "Switched to power-saver"
        ;;

    "enable_cpu"|"disable_cpu"|"enable_wifi"|"disable_wifi"|"enable_audio"|"disable_audio"|"enable_pcie"|"disable_pcie"|"enable_usb"|"disable_usb"|"enable_threshold"|"disable_threshold"|"start_tlp"|"stop_tlp")
        send_notification "Power Mode" "Command '$COMMAND' is not used with power-profiles-daemon"
        ;;

    *)
        # Preserve old behavior: unknown command acts as toggle.
        "$0" toggle
        ;;
esac
