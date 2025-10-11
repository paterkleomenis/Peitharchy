#!/usr/bin/env bash

# macOS-style Power Menu for Waybar
# Beautiful power menu with glass effects

# Check if rofi is available
if ! command -v rofi &> /dev/null; then
    echo "install rofi"
    exit 1
fi

# Power menu options with beautiful icons
options=" Shutdown\n Reboot\n Logout\n Lock\n Suspend"

# Rofi power menu with custom theme
chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu")

case $chosen in
    " Shutdown")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Logout")
        if command -v hyprctl &> /dev/null; then
            hyprctl dispatch exit
        elif command -v swaymsg &> /dev/null; then
            swaymsg exit
        else
            pkill -KILL -u "$USER"
        fi
        ;;
    " Lock")
        # Lock screen - try different lock commands
        if command -v hyprlock &> /dev/null; then
            hyprlock
        elif command -v swaylock &> /dev/null; then
            swaylock -f -c 000000 --inside-color 373445 --ring-color 7aa2f7 --key-hl-color f7768e
        elif command -v gtklock &> /dev/null; then
            gtklock
        else
            notify-send "Lock Screen" "No lock screen application found"
        fi
        ;;
    " Suspend")
        systemctl suspend
        ;;
esac
 -f -c 000000
