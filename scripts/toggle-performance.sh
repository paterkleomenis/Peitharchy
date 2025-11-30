#!/usr/bin/env bash
# Peitharchy Consolidated Power Manager
# Handles switching modes (Powersave/Performance) AND granular TLP settings.

MODE_FILE="$HOME/.cache/cpu_mode"
TLP_CONF="/etc/tlp.conf"
mkdir -p "$(dirname "$MODE_FILE")"

# --- INTERNAL HELPER FUNCTIONS FOR TLP ---

set_param() {
    local param=$1
    local value=$2
    if grep -q "^#$param" "$TLP_CONF"; then
        sed -i "s|^#$param=.*|$param=$value|" "$TLP_CONF"
    elif grep -q "^$param" "$TLP_CONF"; then
        sed -i "s|^$param=.*|$param=$value|" "$TLP_CONF"
    else
        echo "$param=$value" >> "$TLP_CONF"
    fi
}

comment_param() {
    local param=$1
    sed -i "s/^\($param=.*\)/# \1/" "$TLP_CONF"
    sed -i "/^$param=/s/^/#/" "$TLP_CONF"
    sed -i "/^#$param=/s/^#//" "$TLP_CONF"
    sed -i "/^\(.*\)$param=.*/s/^/#/" "$TLP_CONF"
}

apply_tlp() {
    # Silently start TLP to apply changes
    tlp start > /dev/null 2>&1
}

# --- COMMAND HANDLING ---

COMMAND=$1

case "$COMMAND" in
    "toggle")
        # Main Logic: Switch between Performance and Powersave
        if [[ -f "$MODE_FILE" ]]; then
            CURRENT_MODE=$(cat "$MODE_FILE")
        else
            CURRENT_MODE="powersave"
        fi

        if [[ "$CURRENT_MODE" == "powersave" ]]; then
            # -> PERFORMANCE MODE
            # 1. CPU Governor (auto-cpufreq)
            sudo /usr/local/bin/auto-cpufreq --force performance

            # 2. Hyprland Visuals
            hyprctl keyword misc:vfr false

            # 3. Disable TLP Power Savings (via self calls with sudo)
            sudo "$0" internal_disable_wifi
            sudo "$0" internal_disable_audio
            sudo "$0" internal_disable_pcie
            sudo "$0" internal_disable_usb

            echo "performance" > "$MODE_FILE"
            notify-send "Power Mode" "Switched to Performance mode ⚡"
        else
            # -> POWERSAVE MODE
            # 1. CPU Governor (auto-cpufreq)
            sudo /usr/local/bin/auto-cpufreq --force powersave

            # 2. Hyprland Visuals
            hyprctl keyword misc:vfr true

            # 3. Enable TLP Power Savings
            sudo "$0" internal_enable_wifi
            sudo "$0" internal_enable_audio
            sudo "$0" internal_enable_pcie
            sudo "$0" internal_enable_usb

            # 4. Bluetooth Check
            if command -v bluetoothctl &> /dev/null; then
                if [[ -z $(bluetoothctl devices Connected) ]]; then
                    bluetoothctl power off
                fi
            fi

            echo "powersave" > "$MODE_FILE"
            notify-send "Power Mode" "Switched to Power Save mode 🌿"
        fi
        ;;

    # --- INTERNAL TLP COMMANDS (Called via sudo) ---
    
    "disable_cpu")
        comment_param "CPU_ENERGY_PERF_POLICY_ON_AC"
        comment_param "CPU_ENERGY_PERF_POLICY_ON_BAT"
        comment_param "CPU_SCALING_GOVERNOR_ON_AC"
        comment_param "CPU_SCALING_GOVERNOR_ON_BAT"
        comment_param "CPU_MIN_PERF_ON_AC"
        comment_param "CPU_MIN_PERF_ON_BAT"
        comment_param "CPU_MAX_PERF_ON_AC"
        comment_param "CPU_MAX_PERF_ON_BAT"
        comment_param "CPU_BOOST_ON_AC"
        comment_param "CPU_BOOST_ON_BAT"
        apply_tlp
        ;;

    "enable_wifi"|"internal_enable_wifi")
        set_param "WIFI_PWR_ON_BAT" "on"
        apply_tlp
        ;;
    "disable_wifi"|"internal_disable_wifi")
        set_param "WIFI_PWR_ON_BAT" "off"
        apply_tlp
        ;;

    "enable_audio"|"internal_enable_audio")
        set_param "SOUND_POWER_SAVE_ON_BAT" "1"
        apply_tlp
        ;;
    "disable_audio"|"internal_disable_audio")
        set_param "SOUND_POWER_SAVE_ON_BAT" "0"
        apply_tlp
        ;;

    "enable_pcie"|"internal_enable_pcie")
        set_param "PCIE_ASPM_ON_BAT" "powersupersave"
        apply_tlp
        ;;
    "disable_pcie"|"internal_disable_pcie")
        set_param "PCIE_ASPM_ON_BAT" "default"
        apply_tlp
        ;;

    "enable_usb"|"internal_enable_usb")
        set_param "USB_AUTOSUSPEND" "1"
        apply_tlp
        ;;
    "disable_usb"|"internal_disable_usb")
        set_param "USB_AUTOSUSPEND" "0"
        apply_tlp
        ;;

    "enable_threshold")
        set_param "START_CHARGE_THRESH_BAT0" "40"
        set_param "STOP_CHARGE_THRESH_BAT0" "80"
        apply_tlp
        ;;
    "disable_threshold")
        sed -i 's/^START_CHARGE_THRESH_BAT0/#START_CHARGE_THRESH_BAT0/g' "$TLP_CONF"
        sed -i 's/^STOP_CHARGE_THRESH_BAT0/#STOP_CHARGE_THRESH_BAT0/g' "$TLP_CONF"
        apply_tlp
        ;;

    "start_tlp")
        systemctl enable --now tlp
        ;;
    "stop_tlp")
        systemctl disable --now tlp
        ;;

    *)
        # Default action (no args) = Toggle Mode
        # We recursively call this script with "toggle" to share the logic
        "$0" toggle
        ;;
esac
