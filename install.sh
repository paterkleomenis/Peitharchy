#!/bin/bash

# Peitharchy - Arch Linux Hyprland Setup Installation Script
# This script installs all necessary packages, configurations, and the Kora icon theme

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

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_step "Starting Peitharchy installation..."
echo ""

# Update system
print_step "Updating system..."
sudo pacman -Syu --noconfirm

# Install main packages
print_step "Installing main packages..."
sudo pacman -S --needed --noconfirm \
  hyprland hyprpaper hypridle hyprlock hyprshot hyprsunset \
  waybar rofi cliphist wl-clipboard libnotify \
  polkit-gnome xdg-desktop-portal-hyprland xdg-desktop-portal-gtk swaync \
  playerctl jq grim slurp \
  nautilus network-manager-applet blueman \
  gnome-keyring libsecret polkit gcr \
  greetd greetd-tuigreet flameshot \
  wireplumber pavucontrol alsa-utils \
  gst-plugins-good gst-plugins-bad gst-plugins-ugly \
  kdeconnect \
  neovim nano curl wget unzip p7zip tar base-devel git \
  ttf-jetbrains-mono-nerd inter-font \
  noto-fonts noto-fonts-cjk noto-fonts-emoji \
  gnome-system-monitor baobab pipewire pipewire-alsa pipewire-pulse pipewire-jack \
  kitty gtk3 gtk4 nwg-look gnome-themes-extra dconf

print_step "Main packages installed successfully!"

# Install paru (AUR helper) if not already installed
if ! command -v paru &> /dev/null; then
    print_step "Installing paru (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR"
    print_step "Paru installed successfully!"
else
    print_info "Paru is already installed"
fi

# Install AUR packages
print_step "Installing AUR packages..."
paru -S --needed --noconfirm xcursor-breeze ghostty

# Install Flatpak
print_step "Installing Flatpak..."
sudo pacman -S --needed --noconfirm flatpak

# Add Flathub repository
print_step "Adding Flathub repository..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install MissionCenter
print_step "Installing MissionCenter..."
flatpak install -y flathub io.missioncenter.MissionCenter

# Install Kora icon theme
print_step "Installing Kora icon theme..."
if [ -f "$SCRIPT_DIR/kora-1-7-2.tar.xz" ]; then
    mkdir -p ~/.local/share/icons
    tar -xf "$SCRIPT_DIR/kora-1-7-2.tar.xz" -C ~/.local/share/icons/
    print_step "Kora icon theme installed successfully!"
else
    print_warning "kora-1-7-2.tar.xz not found in $SCRIPT_DIR. Skipping icon theme installation."
fi

# Create necessary directories
print_step "Creating configuration directories..."
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/waybar/scripts
mkdir -p ~/.config/rofi
mkdir -p ~/.config/swaync
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0
mkdir -p ~/.local/bin
mkdir -p ~/Pictures/wallpapers
mkdir -p ~/Downloads
mkdir -p ~/Documents

# Copy Hyprland configuration files
print_step "Copying Hyprland configuration files..."
if [ -d "$SCRIPT_DIR/hyprland" ]; then
    cp -r "$SCRIPT_DIR/hyprland"/* ~/.config/hypr/

    # Update hyprpaper.conf with current user's home directory
    if [ -f ~/.config/hypr/hyprpaper.conf ]; then
        sed -i "s|\$HOME|$HOME|g" ~/.config/hypr/hyprpaper.conf
        print_info "Updated hyprpaper.conf with your home directory"
    fi

    print_step "Hyprland configs copied successfully!"
else
    print_warning "Hyprland directory not found. Skipping Hyprland configs."
fi

# Copy scripts
print_step "Copying scripts..."
if [ -d "$SCRIPT_DIR/scripts" ]; then
    # Copy to ~/.local/bin
    cp -r "$SCRIPT_DIR/scripts"/* ~/.local/bin/
    chmod +x ~/.local/bin/*.sh

    # Symlink to waybar scripts directory (avoid duplication)
    ln -sf ~/.local/bin/*.sh ~/.config/waybar/scripts/

    print_step "Scripts copied and made executable!"
else
    print_warning "Scripts directory not found. Skipping scripts."
fi

# Copy waybar config if it exists
if [ -f "$SCRIPT_DIR/config" ]; then
    print_step "Copying Waybar config..."
    cp "$SCRIPT_DIR/config" ~/.config/waybar/config
fi

# Copy waybar style if it exists
if [ -f "$SCRIPT_DIR/style.css" ]; then
    print_step "Copying Waybar style..."
    cp "$SCRIPT_DIR/style.css" ~/.config/waybar/style.css
fi

# Copy rofi config if it exists
if [ -f "$SCRIPT_DIR/rofi/config.rasi" ]; then
    print_step "Copying Rofi config..."
    cp "$SCRIPT_DIR/rofi/config.rasi" ~/.config/rofi/config.rasi
fi

# Copy wallpapers
print_step "Copying wallpapers..."
if [ -d "$SCRIPT_DIR/wallpapers" ]; then
    cp -r "$SCRIPT_DIR/wallpapers"/* ~/Pictures/wallpapers/
    print_step "Wallpapers copied successfully!"
else
    print_warning "Wallpapers directory not found. Skipping wallpapers."
fi

# Copy GTK configuration files (ONLY use provided configs)
print_step "Copying GTK configuration files..."

# Copy GTK 3.0 configs
if [ -d "$SCRIPT_DIR/gtk-3.0" ]; then
    cp -r "$SCRIPT_DIR/gtk-3.0"/* ~/.config/gtk-3.0/

    # Update bookmarks with current user's home directory
    if [ -f ~/.config/gtk-3.0/bookmarks ]; then
        sed -i "s|\$HOME|$HOME|g" ~/.config/gtk-3.0/bookmarks
    fi

    print_step "GTK 3.0 configs copied!"
else
    print_error "gtk-3.0 directory not found! Cannot continue."
    exit 1
fi

# Copy GTK 4.0 configs
if [ -d "$SCRIPT_DIR/gtk-4.0" ]; then
    cp -r "$SCRIPT_DIR/gtk-4.0"/* ~/.config/gtk-4.0/
    print_step "GTK 4.0 configs copied!"
else
    print_error "gtk-4.0 directory not found! Cannot continue."
    exit 1
fi

print_step "GTK theme configured (dark mode with Kora icons)!"

# Set GNOME/GTK preferences via gsettings
print_step "Applying GNOME/GTK settings..."
gsettings set org.gnome.desktop.interface gtk-theme "HighContrastInverse"
gsettings set org.gnome.desktop.interface icon-theme "kora"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface font-name "Inter,  10"
print_step "GTK theme, icons, and font settings applied!"

# Enable greetd service
print_step "Enabling greetd service..."
sudo systemctl enable greetd

# Configure tuigreet
print_step "Configuring tuigreet..."
if [ -f "$SCRIPT_DIR/greetd/config.toml" ]; then
    sudo mkdir -p /etc/greetd
    sudo cp "$SCRIPT_DIR/greetd/config.toml" /etc/greetd/config.toml
    print_step "Greetd config copied from provided file!"
else
    print_warning "greetd/config.toml not found. Creating default config..."
    sudo mkdir -p /etc/greetd
    sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd Hyprland"
user = "greeter"
EOF
fi

# Disable other display managers if they exist
for dm in gdm sddm lightdm lxdm; do
    if systemctl is-enabled "$dm" &> /dev/null; then
        print_warning "Disabling $dm..."
        sudo systemctl disable "$dm"
    fi
done

# Add user to necessary groups
print_step "Adding user to necessary groups..."
sudo usermod -aG input,video,audio "$USER"

print_step "Installation complete!"
echo ""
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_info "  Post-installation notes:"
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Reboot your system to apply all changes"
echo "2. After reboot, you'll be greeted by tuigreet"
echo "3. Select Hyprland as your session"
echo "4. Your Hyprland environment should start with all configurations"
echo ""
echo "Configuration locations:"
echo "  - Hyprland: ~/.config/hypr/"
echo "  - Waybar: ~/.config/waybar/"
echo "  - Rofi: ~/.config/rofi/"
echo "  - Scripts: ~/.local/bin/ and ~/.config/waybar/scripts/"
echo "  - Icons: ~/.local/share/icons/"
echo "  - Wallpapers: ~/Pictures/wallpapers/"
echo "  - GTK: ~/.config/gtk-3.0/ and ~/.config/gtk-4.0/"
echo ""
echo "Installed terminals:"
echo "  - kitty (default)"
echo "  - ghostty"
echo ""
echo "Theme configuration:"
echo "  - GTK: HighContrastInverse (dark mode with custom colors)"
echo "  - Icons: Kora"
echo "  - Cursor: Breeze"
echo "  - Font: Inter, 10"
echo "  - Custom colors.css applied"
echo ""
echo "You can further customize GTK themes using:"
echo "  - nwg-look (installed)"
echo ""
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_step "Enjoy your Hyprland setup! 🚀"
