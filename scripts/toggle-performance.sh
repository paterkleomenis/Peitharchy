#!/usr/bin/env bash
MODE_FILE="$HOME/.cache/cpu_mode"
mkdir -p "$(dirname "$MODE_FILE")"

if [[ -f "$MODE_FILE" ]]; then
    MODE=$(cat "$MODE_FILE")
else
    MODE="powersave"
fi

if [[ "$MODE" == "powersave" ]]; then
    pkexec /usr/local/bin/auto-cpufreq --force performance
    echo "performance" > "$MODE_FILE"
    notify-send "CPU Mode" "Switched to Performance mode ⚡"
else
    pkexec /usr/local/bin/auto-cpufreq --force powersave
    echo "powersave" > "$MODE_FILE"
    notify-send "CPU Mode" "Switched to Power Save mode 🌿"
fi
