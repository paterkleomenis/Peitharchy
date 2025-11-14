#!/usr/bin/env bash

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

# Check for required dependencies
check_dependencies() {
    print_step "Checking for required dependencies..."
    local missing=()
    # Only check for tools needed by the install script itself
    # (jq and wget will be installed by the script)
    for cmd in git tar; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done

    if [ ${#missing[@]} -gt 0 ]; then
        print_error "Missing required dependencies: ${missing[*]}"
        print_info "Install them with: sudo pacman -S ${missing[*]}"
        exit 1
    fi
    print_step "All required dependencies found!"
}

# Backup existing configurations
backup_existing_configs() {
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    local needs_backup=false

    # Check if any configs exist
    for dir in ~/.config/hypr ~/.config/waybar ~/.config/rofi ~/.config/gtk-3.0 ~/.config/gtk-4.0; do
        if [ -d "$dir" ]; then
            needs_backup=true
            break
        fi
    done

    if [ "$needs_backup" = true ]; then
        print_step "Backing up existing configurations to $backup_dir..."
        mkdir -p "$backup_dir"

        [ -d ~/.config/hypr ] && cp -r ~/.config/hypr "$backup_dir/"
        [ -d ~/.config/waybar ] && cp -r ~/.config/waybar "$backup_dir/"
        [ -d ~/.config/rofi ] && cp -r ~/.config/rofi "$backup_dir/"
        [ -d ~/.config/gtk-3.0 ] && cp -r ~/.config/gtk-3.0 "$backup_dir/"
        [ -d ~/.config/gtk-4.0 ] && cp -r ~/.config/gtk-4.0 "$backup_dir/"

        print_info "Backup created at: $backup_dir"
    else
        print_info "No existing configurations found, skipping backup"
    fi
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

# Check dependencies first
check_dependencies

# Backup existing configs
backup_existing_configs

# Refresh mirror list and update system
print_step "Refreshing package databases..."
print_info "If you encounter mirror errors, you may need to update your mirrorlist"
print_info "Run: sudo pacman -Sy archlinux-keyring && sudo pacman -Syu"

# Try to update system, with better error handling
print_step "Updating system..."
if ! sudo pacman -Sy --noconfirm; then
    print_warning "Failed to sync package databases"
    print_info "Trying to refresh keyrings..."
    sudo pacman -Sy --noconfirm archlinux-keyring || true
fi

if ! sudo pacman -Su --noconfirm; then
    print_error "Failed to update system packages"
    print_info "This might be due to:"
    echo "  1. Mirror connectivity issues"
    echo "  2. Outdated keyring"
    echo "  3. Network problems"
    echo ""
    print_info "Try these fixes:"
    echo "  1. Update mirrors: sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
    echo "  2. Update keyring: sudo pacman -Sy archlinux-keyring"
    echo "  3. Check network: ping -c 3 archlinux.org"
    echo ""
    read -p "Do you want to continue anyway? (y/N): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Installation aborted"
        exit 1
    fi
fi

# Install main packages
print_step "Installing main packages..."
print_info "This may take a while depending on your connection..."

if ! sudo pacman -S --needed --noconfirm \
  hyprland hyprpaper hypridle hyprlock hyprshot hyprsunset \
  waybar rofi cliphist wl-clipboard libnotify \
  polkit-gnome xdg-desktop-portal-hyprland xdg-desktop-portal-gtk swaync \
  playerctl jq grim slurp \
  nautilus network-manager-applet blueman \
  gnome-keyring libsecret polkit gcr \
  greetd greetd-tuigreet flameshot \
  wireplumber pavucontrol alsa-utils \
  gst-plugins-good gst-plugins-bad gst-plugins-ugly \
  kdeconnect brightnessctl firefox \
  neovim nano curl wget unzip p7zip tar base-devel git ark \
  ttf-jetbrains-mono-nerd inter-font \
  noto-fonts noto-fonts-cjk noto-fonts-emoji \
  baobab pipewire pipewire-alsa pipewire-pulse pipewire-jack \
  kitty gtk3 gtk4 nwg-look gnome-themes-extra dconf; then
    print_error "Failed to install some packages"
    print_warning "Common causes:"
    echo "  - Mirror is down or slow"
    echo "  - Package signing issues"
    echo "  - Network connectivity problems"
    echo ""
    print_info "You can try:"
    echo "  1. Run the script again"
    echo "  2. Manually install failed packages"
    echo "  3. Update mirrors with reflector"
    echo ""
    read -p "Continue with installation? (y/N): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

print_step "Main packages installed successfully!"

# Install paru (AUR helper) if not already installed
print_step "Checking AUR availability..."
if ping -c 1 aur.archlinux.org &> /dev/null; then
    print_info "AUR is accessible"
    AUR_AVAILABLE=true
else
    print_warning "Cannot reach AUR (aur.archlinux.org)"
    print_warning "AUR packages will be skipped"
    AUR_AVAILABLE=false
fi

if [ "$AUR_AVAILABLE" = true ]; then
    if ! command -v paru &> /dev/null; then
        print_step "Installing paru (AUR helper)..."
        cd /tmp
        if git clone https://aur.archlinux.org/paru.git 2>/dev/null; then
            cd paru
            makepkg -si --noconfirm
            cd "$SCRIPT_DIR"
            print_step "Paru installed successfully!"
        else
            print_error "Failed to clone paru from AUR"
            AUR_AVAILABLE=false
        fi
    else
        print_info "Paru is already installed"
    fi
fi

# Install AUR packages (optional)
if [ "$AUR_AVAILABLE" = true ]; then
    print_step "Installing AUR packages..."

    # Try to install AUR packages
    if paru -S --needed --noconfirm xcursor-breeze ghostty pamac-all 2>/dev/null; then
        print_step "AUR packages installed successfully!"
    else
        print_warning "Failed to install some AUR packages"
        print_info "You can install them manually later with: paru -S xcursor-breeze ghostty pamac-all"
    fi
else
    print_warning "Skipping AUR packages (AUR unavailable)"
    print_info "Alternative cursor themes available in official repos:"
    echo "  - sudo pacman -S xcursor-themes"
    echo "  - Or use system default cursor"
    print_info "Ghostty terminal skipped - kitty will be your default terminal"
fi

# Install Flatpak
print_step "Installing Flatpak..."
sudo pacman -S --needed --noconfirm flatpak

# Add Flathub repository
print_step "Adding Flathub repository..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install MissionCenter
print_step "Installing MissionCenter..."
flatpak install -y flathub io.missioncenter.MissionCenter

# Install Nomacs (image viewer)
print_step "Installing Nomacs (image viewer)..."
flatpak install -y flathub org.nomacs.ImageLounge

# Make Nomacs the default image viewer for common types
if command -v xdg-mime >/dev/null 2>&1; then
  print_info "Setting Nomacs as default image viewer (png/jpg/webp/svg)..."
  xdg-mime default org.nomacs.ImageLounge.desktop image/png
  xdg-mime default org.nomacs.ImageLounge.desktop image/jpeg
  xdg-mime default org.nomacs.ImageLounge.desktop image/webp
  xdg-mime default org.nomacs.ImageLounge.desktop image/svg+xml
fi

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
mkdir -p ~/.config/rofi
mkdir -p ~/.config/swaync
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0
mkdir -p ~/.config/kitty
mkdir -p ~/.local/bin
mkdir -p ~/Pictures/wallpapers
mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Downloads
mkdir -p ~/Documents
mkdir -p ~/Pictures
mkdir -p ~/Music
mkdir -p ~/Videos
xdg-user-dirs-update

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

# Copy scripts to ~/.local/bin only (no duplication)
print_step "Copying scripts..."
if [ -d "$SCRIPT_DIR/scripts" ]; then
    # Copy to ~/.local/bin
    cp -r "$SCRIPT_DIR/scripts"/* ~/.local/bin/
    chmod +x ~/.local/bin/*.sh

    print_step "Scripts copied to ~/.local/bin and made executable!"
else
    print_warning "Scripts directory not found. Skipping scripts."
fi

# Copy waybar config if it exists
if [ -f "$SCRIPT_DIR/config" ]; then
    print_step "Copying Waybar config..."
    cp "$SCRIPT_DIR/config" ~/.config/waybar/config

    # Update waybar config to use ~/.local/bin for scripts
    sed -i 's|~/.config/waybar/scripts/|~/.local/bin/|g' ~/.config/waybar/config
    print_info "Updated Waybar config to use ~/.local/bin for scripts"
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

# Copy kitty config if it exists
if [ -f "$SCRIPT_DIR/kitty/kitty.conf" ]; then
    print_step "Copying Kitty terminal config..."
    cp "$SCRIPT_DIR/kitty/kitty.conf" ~/.config/kitty/kitty.conf
    print_step "Kitty config copied successfully!"
else
    print_warning "Kitty config not found. Skipping kitty configuration."
fi

# Copy wallpapers
print_step "Copying wallpapers..."
if [ -d "$SCRIPT_DIR/wallpapers" ]; then
    cp -r "$SCRIPT_DIR/wallpapers"/* ~/Pictures/wallpapers/
    print_step "Wallpapers copied successfully!"
else
    print_warning "Wallpapers directory not found. Skipping wallpapers."
fi

# Copy GTK configuration files (Optional - ask user)
echo ""
print_info "GTK theme configuration:"
print_warning "This will overwrite your current GTK 3.0/4.0 theme files"

# Check if user has custom themes
CUSTOM_GTK=false
if [ -f ~/.config/gtk-3.0/gtk.gresource ] || [ -f ~/.config/gtk-4.0/gtk.gresource ]; then
    print_info "Custom GTK theme detected!"
    CUSTOM_GTK=true
fi

if [ "$CUSTOM_GTK" = true ]; then
    print_warning "You appear to have a custom GTK theme installed"
    read -p "Do you want to replace it with Peitharchy GTK theme? (y/N): " -r
    INSTALL_GTK=$REPLY
else
    read -p "Install Peitharchy GTK theme? (Y/n): " -r
    INSTALL_GTK=${REPLY:-Y}
fi

if [[ $INSTALL_GTK =~ ^[Yy]$ ]]; then
    print_step "Installing GTK configuration files..."

    # Copy GTK 3.0 configs
    if [ -d "$SCRIPT_DIR/gtk-3.0" ]; then
        cp -r "$SCRIPT_DIR/gtk-3.0"/* ~/.config/gtk-3.0/

        # Update bookmarks with current user's home directory
        if [ -f ~/.config/gtk-3.0/bookmarks ]; then
            sed -i "s|\$HOME|$HOME|g" ~/.config/gtk-3.0/bookmarks
        fi

        print_step "GTK 3.0 configs copied!"
    else
        print_warning "gtk-3.0 directory not found in source. Skipping."
    fi

    # Copy GTK 4.0 configs
    if [ -d "$SCRIPT_DIR/gtk-4.0" ]; then
        cp -r "$SCRIPT_DIR/gtk-4.0"/* ~/.config/gtk-4.0/
        print_step "GTK 4.0 configs copied!"
    else
        print_warning "gtk-4.0 directory not found in source. Skipping."
    fi

    print_step "GTK theme configured!"

    # Set GNOME/GTK preferences via gsettings
    print_step "Applying GNOME/GTK settings..."
    gsettings set org.gnome.desktop.interface icon-theme "kora" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name "Inter,  10" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface gtk-theme "HighContrastInverse" 2>/dev/null || true
    print_step "GTK settings applied!"
else
    print_info "Skipping GTK theme installation - keeping your custom theme"
    print_info "Your custom GTK theme will be preserved"
fi

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

# Configure PAM for greetd
print_step "Configuring PAM for greetd..."
sudo tee /etc/pam.d/greetd > /dev/null <<EOF
#%PAM-1.0

auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
account    include      system-local-login
session    include      system-local-login
auth       optional     pam_gnome_keyring.so
session    optional     pam_gnome_keyring.so auto_start
EOF

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
echo "  - Scripts: ~/.local/bin/"
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
