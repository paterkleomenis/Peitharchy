#!/usr/bin/env bash
# hyprsunset.sh: Waybar status + toggle + scroll adjust (warm/cool)
# Usage:
#   hyprsunset.sh                -> JSON status for Waybar
#   hyprsunset.sh toggle         -> toggle on/off
#   hyprsunset.sh warmer         -> lower K (warmer)
#   hyprsunset.sh cooler         -> raise K (cooler)

set -euo pipefail

STATE="${XDG_CACHE_HOME:-$HOME/.cache}/hyprsunset.temp"
DEFAULT_TEMP="${TEMP:-3500}"   # default start temp
STEP="${STEP:-200}"            # scroll step
MIN_K="${MIN_K:-2500}"
MAX_K="${MAX_K:-6500}"

ICON_ON="󰖔"
ICON_OFF="󰖔"

is_running() { pgrep -x hyprsunset >/dev/null 2>&1; }

read_temp() {
  if [[ -f "$STATE" ]]; then
    awk 'NR==1{print;exit}' "$STATE"
  else
    echo "$DEFAULT_TEMP"
  fi
}

save_temp() { printf '%s\n' "$1" >"$STATE"; }

apply_temp() {
  local k="$1"
  save_temp "$k"
  if is_running; then
    hyprctl hyprsunset temperature "$k" >/dev/null 2>&1 || true
  else
    nohup hyprsunset --temperature "$k" >/dev/null 2>&1 & disown || true
  fi
}

toggle() {
  if is_running; then
    # Try graceful shutdown first (SIGTERM)
    killall hyprsunset 2>/dev/null || true
    sleep 0.2
    # Force kill if still running (SIGKILL)
    if is_running; then
      killall -9 hyprsunset 2>/dev/null || true
    fi
    hyprctl hyprsunset identity >/dev/null 2>&1 || true
  else
    apply_temp "$(read_temp)"
  fi
}

bump() {
  local dir="$1"
  local k
  k="$(read_temp)"
  if [[ "$dir" == "warmer" ]]; then
    # Warmer = lower Kelvin
    k=$(( k - STEP ))
    (( k < MIN_K )) && k="$MIN_K"
  else
    # Cooler = higher Kelvin
    k=$(( k + STEP ))
    (( k > MAX_K )) && k="$MAX_K"
  fi
  apply_temp "$k"
}

print_status() {
  local k running
  k="$(read_temp)"
  if is_running; then
    printf '{"text":" %s ","class":"on","tooltip":"Night light ON (%sK)"}\n' "$ICON_ON" "$k"
  else
    printf '{"text":" %s ","class":"off","tooltip":"Night light OFF (last %sK)"}\n' "$ICON_OFF" "$k"
  fi
}

case "${1:-}" in
  toggle)  toggle ;;
  warmer)  bump warmer ;;
  cooler)  bump cooler ;;
  *)       print_status ;;
esac
