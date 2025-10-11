# ~/.config/waybar/scripts/clipboard_menu.sh
sel="$(cliphist list | rofi -dmenu -i -p '📋 Clipboard')"
[ -z "$sel" ] && exit 0
id="${sel%% *}"
mime="$(cliphist decode "$id" -m)"
if printf '%s' "$mime" | grep -q '^image/'; then
  cliphist decode "$id" | wl-copy --type "$mime"
else
  cliphist decode "$id" | wl-copy
fi
notify-send 'Clipboard' 'Copied selection to clipboard'
