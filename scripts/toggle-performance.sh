#!/usr/bin/env bash
# Peitharchy Consolidated Power Manager
# Handles switching modes (Powersave/Performance) AND granular TLP settings.

# Use SUDO_USER's home if running under sudo, otherwise use HOME
if [[ -n "$SUDO_USER" ]]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME="$HOME"
fi

MODE_FILE="$USER_HOME/.cache/cpu_mode"
TLP_CONF="/etc/tlp.conf"
mkdir -p "$(dirname "$MODE_FILE")"

# --- NOTIFICATION HELPER ---
# Handles notify-send properly when running under sudo
send_notification() {
    local title="$1"
    local message="$2"
    
    if [[ -n "$SUDO_USER" ]]; then
        # Running under sudo, use the original user's session
        local user_id=$(id -u "$SUDO_USER")
        sudo -u "$SUDO_USER" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${user_id}/bus" notify-send "$title" "$message" 2>/dev/null || true
    else
        notify-send "$title" "$message" 2>/dev/null || true
    fi
}

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

apply_tlp() {
    tlp start > /dev/null 2>&1
}

# --- COMMAND HANDLING ---

COMMAND=$1

case "$COMMAND" in
    "toggle")
        if [[ -f "$MODE_FILE" ]]; then
            CURRENT_MODE=$(cat "$MODE_FILE")
        else
            CURRENT_MODE="powersave"
        fi

        if [[ "$CURRENT_MODE" == "powersave" ]]; then
            sudo /usr/local/bin/auto-cpufreq --force performance
            hyprctl keyword misc:vfr false
            sudo "$0" internal_disable_wifi
            sudo "$0" internal_disable_audio
            sudo "$0" internal_disable_pcie
            sudo "$0" internal_disable_usb
            echo "performance" > "$MODE_FILE"
            send_notification "Power Mode" "Switched to Performance mode ⚡"
        else
            sudo /usr/local/bin/auto-cpufreq --force powersave
            hyprctl keyword misc:vfr true
            sudo "$0" internal_enable_wifi
            sudo "$0" internal_enable_audio
            sudo "$0" internal_enable_pcie
            sudo "$0" internal_enable_usb
            if command -v bluetoothctl &> /dev/null; then
                if [[ -z $(bluetoothctl devices Connected) ]]; then
                    bluetoothctl power off
                fi
            fi
            echo "powersave" > "$MODE_FILE"
            send_notification "Power Mode" "Switched to Power Save mode 🌿"
        fi
        ;;

    "enable_cpu")
        # Enable TLP CPU = disable auto-cpufreq
        systemctl stop auto-cpufreq
        systemctl disable auto-cpufreq
        set_param "CPU_SCALING_GOVERNOR_ON_AC" "performance"
        set_param "CPU_SCALING_GOVERNOR_ON_BAT" "powersave"
        set_param "CPU_ENERGY_PERF_POLICY_ON_AC" "balance_performance"
        set_param "CPU_ENERGY_PERF_POLICY_ON_BAT" "balance_power"
        apply_tlp
        send_notification "CPU Management" "TLP now controls CPU ⚙️"
        ;;

    "disable_cpu")
        # Disable TLP CPU = enable auto-cpufreq
        set_param "CPU_SCALING_GOVERNOR_ON_AC" "keep"
        set_param "CPU_SCALING_GOVERNOR_ON_BAT" "keep"
        set_param "CPU_SCALING_MIN_FREQ_ON_AC" "keep"
        set_param "CPU_SCALING_MIN_FREQ_ON_BAT" "keep"
        set_param "CPU_SCALING_MAX_FREQ_ON_AC" "keep"
        set_param "CPU_SCALING_MAX_FREQ_ON_BAT" "keep"
        set_param "CPU_BOOST_ON_AC" "keep"
        set_param "CPU_BOOST_ON_BAT" "keep"
        set_param "CPU_ENERGY_PERF_POLICY_ON_AC" "keep"
        set_param "CPU_ENERGY_PERF_POLICY_ON_BAT" "keep"
        set_param "CPU_MIN_PERF_ON_AC" "keep"
        set_param "CPU_MIN_PERF_ON_BAT" "keep"
        set_param "CPU_MAX_PERF_ON_AC" "keep"
        set_param "CPU_MAX_PERF_ON_BAT" "keep"
        apply_tlp
        systemctl enable auto-cpufreq
        systemctl start auto-cpufreq
        send_notification "CPU Management" "auto-cpufreq now controls CPU 🔄"
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
        send_notification "Battery" "Charge limit enabled (40-80%) 🔋"
        ;;

    "disable_threshold")
        sed -i 's/^START_CHARGE_THRESH_BAT0/#START_CHARGE_THRESH_BAT0/g' "$TLP_CONF"
        sed -i 's/^STOP_CHARGE_THRESH_BAT0/#STOP_CHARGE_THRESH_BAT0/g' "$TLP_CONF"
        apply_tlp
        send_notification "Battery" "Charge limit disabled (full charge) 🔌"
        ;;

    "start_tlp")
        systemctl enable --now tlp
        send_notification "TLP" "TLP service started ✓"
        ;;

    "stop_tlp")
        systemctl disable --now tlp
        send_notification "TLP" "TLP service stopped ✗"
        ;;

    *)
        "$0" toggle
        ;;
esac
