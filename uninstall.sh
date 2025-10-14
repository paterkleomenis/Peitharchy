#!/usr/bin/env bash

# Peitharchy - Uninstallation Script
# This script removes Peitharchy configurations and optionally removes installed packages

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
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

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root. It will use sudo when needed."
    exit 1
fi

echo ""
print_warning "╔════════════════════════════════════════════════════════════╗"
print_warning "║          PEITHARCHY UNINSTALLATION SCRIPT                  ║"
print_warning "╚════════════════════════════════════════════════════════════╝"
echo ""
print_warning "This will remove all Peitharchy configurations from your system."
print_warning "Your configuration backups (if any) will NOT be deleted."
echo ""
print_info "The following will be removed:"
echo "  - ~/.config/hypr/"
echo "  - ~/.config/waybar/"
echo "  - ~/.config/rofi/"
echo "  - ~/.config/gtk-3.0/"
echo "  - ~/.config/gtk-4.0/"
echo "  - ~/.local/bin/clipboard_menu.sh"
echo "  - ~/.local/bin/hyprsunset.sh"
echo "  - ~/.local/bin/power-menu.sh"
echo "  - ~/.local/bin/toggle-layout.sh"
echo "  - ~/.local/share/icons/kora*"
echo ""

read -p "Do you want to continue? (yes/no): " -r
echo
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    print_info "Uninstallation cancelled."
    exit 0
fi

# Ask about packages
echo ""
print_info "Do you want to remove installed packages as well?"
print_warning "This will remove Hyprland and all related packages installed by Peitharchy."
print_warning "Only choose 'yes' if you're sure you don't need these packages."
echo ""
read -p "Remove packages? (yes/no): " -r
REMOVE_PACKAGES=$REPLY
echo ""

# Create a final backup before removal
BACKUP_DIR="$HOME/.config-uninstall-backup-$(date +%Y%m%d-%H%M%S)"
print_step "Creating final backup at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

[ -d ~/.config/hypr ] && cp -r ~/.config/hypr "$BACKUP_DIR/"
[ -d ~/.config/waybar ] && cp -r ~/.config/waybar "$BACKUP_DIR/"
[ -d ~/.config/rofi ] && cp -r ~/.config/rofi "$BACKUP_DIR/"
[ -d ~/.config/gtk-3.0 ] && cp -r ~/.config/gtk-3.0 "$BACKUP_DIR/"
[ -d ~/.config/gtk-4.0 ] && cp -r ~/.config/gtk-4.0 "$BACKUP_DIR/"

print_info "Backup created successfully!"

# Remove configuration directories
print_step "Removing Peitharchy configurations..."

if [ -d ~/.config/hypr ]; then
    rm -rf ~/.config/hypr
    print_info "Removed ~/.config/hypr"
fi

if [ -d ~/.config/waybar ]; then
    rm -rf ~/.config/waybar
    print_info "Removed ~/.config/waybar"
fi

if [ -d ~/.config/rofi ]; then
    rm -rf ~/.config/rofi
    print_info "Removed ~/.config/rofi"
fi

if [ -d ~/.config/gtk-3.0 ]; then
    rm -rf ~/.config/gtk-3.0
    print_info "Removed ~/.config/gtk-3.0"
fi

if [ -d ~/.config/gtk-4.0 ]; then
    rm -rf ~/.config/gtk-4.0
    print_info "Removed ~/.config/gtk-4.0"
fi

# Remove scripts
print_step "Removing Peitharchy scripts..."

[ -f ~/.local/bin/clipboard_menu.sh ] && rm -f ~/.local/bin/clipboard_menu.sh
[ -f ~/.local/bin/hyprsunset.sh ] && rm -f ~/.local/bin/hyprsunset.sh
[ -f ~/.local/bin/power-menu.sh ] && rm -f ~/.local/bin/power-menu.sh
[ -f ~/.local/bin/toggle-layout.sh ] && rm -f ~/.local/bin/toggle-layout.sh

print_info "Removed scripts from ~/.local/bin"

# Remove Kora icons
print_step "Removing Kora icon theme..."
if [ -d ~/.local/share/icons ]; then
    rm -rf ~/.local/share/icons/kora*
    print_info "Removed Kora icons"
fi

# Disable greetd if it's enabled
print_step "Checking greetd service..."
if systemctl is-enabled greetd &>/dev/null; then
    print_warning "Disabling greetd service..."
    sudo systemctl disable greetd
    print_info "Greetd disabled. You may want to enable another display manager."
fi

# Remove packages if requested
if [[ $REMOVE_PACKAGES =~ ^[Yy][Ee][Ss]$ ]]; then
    print_step "Removing Peitharchy packages..."

    print_warning "This may take a while..."

    # Remove official repository packages
    sudo pacman -Rns --noconfirm \
        hyprland hyprpaper hypridle hyprlock hyprshot hyprsunset \
        waybar rofi cliphist wl-clipboard \
        swaync playerctl grim slurp \
        greetd greetd-tuigreet flameshot \
        kdeconnect \
        kitty nwg-look 2>/dev/null || print_warning "Some packages may have already been removed or have dependents"

    # Remove AUR packages
    if command -v paru &>/dev/null; then
        print_step "Removing AUR packages..."
        paru -Rns --noconfirm xcursor-breeze ghostty 2>/dev/null || print_warning "Some AUR packages may have already been removed"
    fi

    # Remove Flatpak application
    if command -v flatpak &>/dev/null; then
        print_step "Removing MissionCenter flatpak..."
        flatpak uninstall -y io.missioncenter.MissionCenter 2>/dev/null || print_warning "MissionCenter may have already been removed"
    fi

    print_step "Packages removed successfully!"
else
    print_info "Skipping package removal. Packages remain installed."
fi

# Reset GTK settings
print_step "Resetting GTK settings..."
gsettings reset org.gnome.desktop.interface gtk-theme 2>/dev/null || true
gsettings reset org.gnome.desktop.interface icon-theme 2>/dev/null || true
gsettings reset org.gnome.desktop.interface color-scheme 2>/dev/null || true
print_info "GTK settings reset to defaults"

print_step "Uninstallation complete!"
echo ""
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_info "  Summary"
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Peitharchy has been uninstalled from your system."
echo ""
echo "Backup location: $BACKUP_DIR"
echo ""
if [[ $REMOVE_PACKAGES =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Packages: Removed"
else
    echo "Packages: Not removed (still installed)"
fi
echo ""
echo "Additional backups from installation may exist in:"
echo "  ~/.config-backup-*"
echo ""
print_warning "If you disabled greetd, you may need to:"
echo "  1. Enable another display manager (gdm, sddm, lightdm, etc.)"
echo "  2. Or configure automatic login to console"
echo ""
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
