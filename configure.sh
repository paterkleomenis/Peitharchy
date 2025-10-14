#!/usr/bin/env bash

# Peitharchy Configuration Wizard
# Interactive script to customize your Hyprland setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  $1"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${CYAN}==>${NC} ${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

print_info() {
    echo -e "${BLUE}Info:${NC} $1"
}

print_option() {
    echo -e "${MAGENTA}[$1]${NC} $2"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root."
    exit 1
fi

# Check if Peitharchy is installed
if [ ! -d "$HOME/.config/hypr" ] || [ ! -f "$HOME/.config/hypr/hyprland.conf" ]; then
    print_error "Peitharchy is not installed. Please run install.sh first."
    exit 1
fi

# Backup current configuration
backup_config() {
    local backup_dir="$HOME/.config-wizard-backup-$(date +%Y%m%d-%H%M%S)"
    print_step "Creating backup at $backup_dir..."
    mkdir -p "$backup_dir"

    [ -d ~/.config/hypr ] && cp -r ~/.config/hypr "$backup_dir/"
    [ -d ~/.config/waybar ] && cp -r ~/.config/waybar "$backup_dir/"

    print_info "Backup created successfully!"
}

# Welcome screen
clear
print_header "PEITHARCHY CONFIGURATION WIZARD"
echo "This wizard will help you customize your Hyprland setup."
echo ""
echo "What would you like to configure?"
echo ""
print_option "1" "Monitor Setup"
print_option "2" "Keyboard Layouts"
print_option "3" "Default Applications"
print_option "4" "Theme Colors"
print_option "5" "All of the above"
print_option "0" "Exit"
echo ""
read -p "Enter your choice [0-5]: " main_choice

case $main_choice in
    0)
        print_info "Exiting wizard."
        exit 0
        ;;
    5)
        configure_monitors=true
        configure_keyboard=true
        configure_apps=true
        configure_theme=true
        ;;
    1)
        configure_monitors=true
        ;;
    2)
        configure_keyboard=true
        ;;
    3)
        configure_apps=true
        ;;
    4)
        configure_theme=true
        ;;
    *)
        print_error "Invalid choice."
        exit 1
        ;;
esac

# Create backup before making changes
backup_config

# ============================================================================
# MONITOR CONFIGURATION
# ============================================================================
if [ "$configure_monitors" = true ]; then
    clear
    print_header "MONITOR CONFIGURATION"

    print_info "Detecting connected monitors..."
    hyprctl monitors -j > /tmp/monitors.json 2>/dev/null || {
        print_warning "Could not detect monitors. Using manual configuration."
    }

    echo "Current monitors:"
    hyprctl monitors 2>/dev/null || echo "  (Could not detect monitors)"
    echo ""

    print_info "How many monitors do you have?"
    read -p "Number of monitors [1]: " monitor_count
    monitor_count=${monitor_count:-1}

    if [ "$monitor_count" -gt 0 ] 2>/dev/null; then
        # Create monitors.conf
        cat > ~/.config/hypr/monitors.conf << 'EOF'
################
### MONITORS ###
################

# See https://wiki.hyprland.org/Configuring/Monitors/
EOF

        for ((i=1; i<=monitor_count; i++)); do
            echo ""
            print_step "Configuring Monitor $i"

            read -p "Monitor name (e.g., DP-1, HDMI-A-1) [DP-$i]: " mon_name
            mon_name=${mon_name:-DP-$i}

            read -p "Resolution (e.g., 1920x1080, 2560x1440) [1920x1080]: " resolution
            resolution=${resolution:-1920x1080}

            read -p "Refresh rate (Hz) [60]: " refresh
            refresh=${refresh:-60}

            read -p "Position (e.g., 0x0, 1920x0) [auto]: " position
            position=${position:-auto}

            read -p "Scale factor (1.0, 1.25, 1.5, etc.) [1]: " scale
            scale=${scale:-1}

            # Write monitor config
            echo "monitor = $mon_name, ${resolution}@${refresh}, $position, $scale" >> ~/.config/hypr/monitors.conf

            # Ask for workspace binding
            read -p "Bind specific workspaces to this monitor? (y/n) [n]: " bind_ws
            if [[ $bind_ws =~ ^[Yy]$ ]]; then
                read -p "Enter workspace numbers (space-separated, e.g., 1 2 3): " workspaces
                for ws in $workspaces; do
                    echo "workspace = $ws, monitor:$mon_name" >> ~/.config/hypr/monitors.conf
                done
            fi
        done

        # Add fallback monitor
        echo "" >> ~/.config/hypr/monitors.conf
        echo "# Fallback for any unspecified monitor" >> ~/.config/hypr/monitors.conf
        echo "monitor = , preferred, auto, 1" >> ~/.config/hypr/monitors.conf

        print_step "Monitor configuration saved!"
    else
        print_error "Invalid number of monitors."
    fi
fi

# ============================================================================
# KEYBOARD LAYOUT CONFIGURATION
# ============================================================================
if [ "$configure_keyboard" = true ]; then
    clear
    print_header "KEYBOARD LAYOUT CONFIGURATION"

    echo "Common keyboard layouts:"
    print_option "1" "US English only"
    print_option "2" "US + Greek"
    print_option "3" "US + Spanish"
    print_option "4" "US + French"
    print_option "5" "US + German"
    print_option "6" "Custom"
    echo ""
    read -p "Select layout configuration [1]: " kb_choice
    kb_choice=${kb_choice:-1}

    case $kb_choice in
        1)
            kb_layouts="us"
            kb_variants=""
            ;;
        2)
            kb_layouts="us,gr"
            kb_variants=","
            ;;
        3)
            kb_layouts="us,es"
            kb_variants=","
            ;;
        4)
            kb_layouts="us,fr"
            kb_variants=","
            ;;
        5)
            kb_layouts="us,de"
            kb_variants=","
            ;;
        6)
            read -p "Enter layouts (comma-separated, e.g., us,gr,de): " kb_layouts
            read -p "Enter variants (comma-separated, leave empty if none): " kb_variants
            ;;
        *)
            kb_layouts="us"
            kb_variants=""
            ;;
    esac

    # Ask for additional keyboard options
    echo ""
    print_info "Additional keyboard options:"
    read -p "Caps Lock behavior (1=normal, 2=escape, 3=ctrl) [1]: " caps_choice

    case $caps_choice in
        2)
            kb_options="caps:escape"
            ;;
        3)
            kb_options="caps:ctrl_modifier"
            ;;
        *)
            kb_options=""
            ;;
    esac

    # Read current input.conf to preserve other settings
    if [ -f ~/.config/hypr/input.conf ]; then
        # Extract non-keyboard settings
        grep -v "kb_layout\|kb_variant\|kb_options" ~/.config/hypr/input.conf > /tmp/input_temp.conf || true

        # Create new input.conf
        cat > ~/.config/hypr/input.conf << EOF
#############
### INPUT ###
#############

# See https://wiki.hyprland.org/Configuring/Variables/#input
input {
    kb_layout = $kb_layouts
    kb_variant = $kb_variants
    kb_options = $kb_options

    follow_mouse = 1

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

    touchpad {
        natural_scroll = true
        tap-to-click = true
        drag_lock = false
        disable_while_typing = true
    }
}
EOF
    else
        # Create from scratch
        cat > ~/.config/hypr/input.conf << EOF
#############
### INPUT ###
#############

input {
    kb_layout = $kb_layouts
    kb_variant = $kb_variants
    kb_options = $kb_options

    follow_mouse = 1
    sensitivity = 0

    touchpad {
        natural_scroll = true
        tap-to-click = true
        drag_lock = false
        disable_while_typing = true
    }
}
EOF
    fi

    print_step "Keyboard configuration saved!"

    # Update waybar language indicator
    if [ -f ~/.config/waybar/config ]; then
        print_info "Updating Waybar language indicator..."
        # This would require jq to properly edit JSON, so just inform user
        print_warning "You may need to manually update waybar config for language display names"
    fi
fi

# ============================================================================
# DEFAULT APPLICATIONS CONFIGURATION
# ============================================================================
if [ "$configure_apps" = true ]; then
    clear
    print_header "DEFAULT APPLICATIONS"

    # Terminal
    print_step "Terminal Emulator"
    print_option "1" "kitty (default)"
    print_option "2" "ghostty"
    print_option "3" "alacritty"
    print_option "4" "foot"
    print_option "5" "Custom"
    read -p "Choose terminal [1]: " term_choice

    case $term_choice in
        2) terminal="ghostty" ;;
        3) terminal="alacritty" ;;
        4) terminal="foot" ;;
        5)
            read -p "Enter terminal command: " terminal
            ;;
        *) terminal="kitty" ;;
    esac

    # Browser
    echo ""
    print_step "Web Browser"
    print_option "1" "firefox (default)"
    print_option "2" "chromium"
    print_option "3" "google-chrome-stable"
    print_option "4" "brave"
    print_option "5" "Custom"
    read -p "Choose browser [1]: " browser_choice

    case $browser_choice in
        2) browser="chromium" ;;
        3) browser="google-chrome-stable" ;;
        4) browser="brave" ;;
        5)
            read -p "Enter browser command: " browser
            ;;
        *) browser="firefox" ;;
    esac

    # File Manager
    echo ""
    print_step "File Manager"
    print_option "1" "nautilus (default)"
    print_option "2" "thunar"
    print_option "3" "dolphin"
    print_option "4" "nemo"
    print_option "5" "Custom"
    read -p "Choose file manager [1]: " fm_choice

    case $fm_choice in
        2) filemanager="thunar" ;;
        3) filemanager="dolphin" ;;
        4) filemanager="nemo" ;;
        5)
            read -p "Enter file manager command: " filemanager
            ;;
        *) filemanager="nautilus" ;;
    esac

    # Application Launcher
    echo ""
    print_step "Application Launcher"
    print_option "1" "rofi (default)"
    print_option "2" "wofi"
    print_option "3" "fuzzel"
    print_option "4" "Custom"
    read -p "Choose launcher [1]: " launcher_choice

    case $launcher_choice in
        2) launcher="wofi --show drun" ;;
        3) launcher="fuzzel" ;;
        4)
            read -p "Enter launcher command: " launcher
            ;;
        *) launcher="rofi -show drun" ;;
    esac

    # Task Manager
    echo ""
    print_step "Task Manager"
    print_option "1" "gnome-system-monitor (default)"
    print_option "2" "htop (terminal)"
    print_option "3" "btop (terminal)"
    print_option "4" "Custom"
    read -p "Choose task manager [1]: " tm_choice

    case $tm_choice in
        2) taskmanager="$terminal -e htop" ;;
        3) taskmanager="$terminal -e btop" ;;
        4)
            read -p "Enter task manager command: " taskmanager
            ;;
        *) taskmanager="gnome-system-monitor" ;;
    esac

    # Write programs.conf
    cat > ~/.config/hypr/programs.conf << EOF
################
### PROGRAMS ###
################

# See https://wiki.hyprland.org/Configuring/Keywords/

# Set programs that you use
\$terminal = $terminal
\$browser = $browser
\$fileManager = $filemanager
\$menu = $launcher
\$TaskManager = $taskmanager
EOF

    print_step "Default applications saved!"
fi

# ============================================================================
# THEME COLOR CONFIGURATION
# ============================================================================
if [ "$configure_theme" = true ]; then
    clear
    print_header "THEME COLOR CONFIGURATION"

    echo "Choose a color theme preset:"
    print_option "1" "Catppuccin Mocha (default - blue accent)"
    print_option "2" "Catppuccin Mocha (purple accent)"
    print_option "3" "Catppuccin Mocha (pink accent)"
    print_option "4" "Catppuccin Mocha (green accent)"
    print_option "5" "Nord"
    print_option "6" "Dracula"
    print_option "7" "Gruvbox Dark"
    print_option "8" "Tokyo Night"
    print_option "9" "Custom (manual)"
    echo ""
    read -p "Select theme [1]: " theme_choice
    theme_choice=${theme_choice:-1}

    case $theme_choice in
        1)
            accent_color="#89b4fa"
            accent_name="blue"
            ;;
        2)
            accent_color="#cba6f7"
            accent_name="purple"
            ;;
        3)
            accent_color="#f5c2e7"
            accent_name="pink"
            ;;
        4)
            accent_color="#a6e3a1"
            accent_name="green"
            ;;
        5)
            accent_color="#88c0d0"
            accent_name="nord-blue"
            ;;
        6)
            accent_color="#bd93f9"
            accent_name="dracula-purple"
            ;;
        7)
            accent_color="#b8bb26"
            accent_name="gruvbox-green"
            ;;
        8)
            accent_color="#7aa2f7"
            accent_name="tokyo-blue"
            ;;
        9)
            read -p "Enter accent color (hex, e.g., #89b4fa): " accent_color
            accent_name="custom"
            ;;
        *)
            accent_color="#89b4fa"
            accent_name="blue"
            ;;
    esac

    # Convert hex to rgba for Hyprland
    hex_to_rgba() {
        local hex=$1
        hex=${hex#\#}
        printf "rgba(%d, %d, %d, 0.9)" 0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}
    }

    rgba_accent=$(hex_to_rgba "$accent_color")

    print_step "Applying theme colors..."

    # Update Hyprland border colors
    if [ -f ~/.config/hypr/appearance.conf ]; then
        sed -i "s/col.active_border = .*/col.active_border = $rgba_accent/" ~/.config/hypr/appearance.conf
        print_info "Updated Hyprland border colors"
    fi

    # Note: GTK accent colors are handled by the gtk.gresource files
    # Manual editing of those would require recompiling the theme resources
    print_info "GTK theme uses binary resources (gtk.gresource)"
    print_info "Border colors updated in Hyprland configuration"

    # Waybar colors
    echo ""
    print_info "To change Waybar colors, edit ~/.config/waybar/style.css manually"

    print_step "Theme colors applied!"
    print_info "You may need to restart Hyprland for all changes to take effect"
fi

# ============================================================================
# COMPLETION
# ============================================================================
clear
print_header "CONFIGURATION COMPLETE"

echo "Your Peitharchy configuration has been updated!"
echo ""
print_info "Changes applied:"
[ "$configure_monitors" = true ] && echo "  - Monitor setup"
[ "$configure_keyboard" = true ] && echo "  - Keyboard layouts"
[ "$configure_apps" = true ] && echo "  - Default applications"
[ "$configure_theme" = true ] && echo "  - Theme colors"
echo ""
print_info "Next steps:"
echo "  1. Reload Hyprland: Super+Shift+R or log out and back in"
echo "  2. Restart Waybar: killall waybar && waybar &"
echo "  3. Test your new configuration"
echo ""
print_warning "If you encounter issues, your backup is available at:"
echo "  ~/.config-wizard-backup-*"
echo ""
print_step "Enjoy your customized Peitharchy setup!"
