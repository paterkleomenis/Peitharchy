#!/bin/sh
if command -v hyprlock >/dev/null; then
    hyprlock
else
    notify-send "Lock" "Hyprlock is not installed"
fi
