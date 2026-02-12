#!/usr/bin/env bash

set -u

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/peitharchy"
VERSION_FILE="$STATE_DIR/hyprland.pkgver"
PLUGIN_REPO="https://github.com/hyprwm/hyprland-plugins"
HYPR_PLUGINS=(hyprexpo hyprgrass)
needs_reload=0

mkdir -p "$STATE_DIR"

if ! command -v hyprpm >/dev/null 2>&1; then
    exit 0
fi

current_pkgver="$(pacman -Q hyprland 2>/dev/null | awk '{print $2}')"
last_pkgver=""
[ -f "$VERSION_FILE" ] && last_pkgver="$(cat "$VERSION_FILE" 2>/dev/null)"

if ! hyprpm list 2>/dev/null | grep -q "hyprland-plugins"; then
    hyprpm add "$PLUGIN_REPO" >/dev/null 2>&1 || true
    needs_reload=1
fi

if [ "${1:-}" = "--force" ] || { [ -n "$current_pkgver" ] && [ "$current_pkgver" != "$last_pkgver" ]; }; then
    hyprpm update >/dev/null 2>&1 || true
    for plugin in "${HYPR_PLUGINS[@]}"; do
        hyprpm enable "$plugin" >/dev/null 2>&1 || true
    done
    printf '%s\n' "$current_pkgver" > "$VERSION_FILE"
    needs_reload=1
fi

if [ "$needs_reload" -eq 1 ]; then
    hyprpm reload >/dev/null 2>&1 || true
fi
