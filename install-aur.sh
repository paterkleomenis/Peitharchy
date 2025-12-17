#!/usr/bin/env bash

# Peitharchy AUR Package Installer
# Install AUR packages separately if AUR was unavailable during main installation

set -e

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

clear
echo ""
print_step "Peitharchy AUR Package Installer"
echo ""
print_info "This script installs optional AUR packages for Peitharchy"
echo ""

# Check network connectivity
print_step "Checking network connectivity..."
if ! ping -c 2 archlinux.org &> /dev/null; then
    print_error "No internet connection"
    exit 1
fi
print_info "Network OK"

# Check AUR availability
print_step "Checking AUR availability..."
if ! ping -c 2 aur.archlinux.org &> /dev/null; then
    print_error "Cannot reach aur.archlinux.org"
    echo ""
    print_info "Possible solutions:"
    echo "  1. Wait and try again later (AUR may be temporarily down)"
    echo "  2. Check your DNS settings"
    echo "  3. Try a VPN or different network"
    echo "  4. Use alternative packages:"
    echo "     - sudo pacman -S xcursor-themes (instead of xcursor-breeze)"
    echo "     - Use kitty or alacritty (instead of ghostty)"
    echo ""
    exit 1
fi
print_info "AUR is accessible"

# Check for base-devel
if ! pacman -Qi base-devel &> /dev/null; then
    print_step "Installing base-devel (required for AUR)..."
    sudo pacman -S --needed --noconfirm base-devel
fi

# Check for git
if ! command -v git &> /dev/null; then
    print_step "Installing git (required for AUR)..."
    sudo pacman -S --needed --noconfirm git
fi

# Install paru if not present
if ! command -v paru &> /dev/null; then
    print_step "Installing paru (AUR helper)..."
    echo ""
    print_info "This may take a few minutes..."

    cd /tmp

    # Remove old paru directory if exists
    [ -d paru ] && rm -rf paru

    print_info "Cloning paru from AUR..."
    if ! git clone https://aur.archlinux.org/paru.git; then
        print_error "Failed to clone paru repository"
        print_info "Try manually: cd /tmp && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si"
        exit 1
    fi

    cd paru

    print_info "Building paru..."
    if ! makepkg -si --noconfirm; then
        print_error "Failed to build paru"
        print_info "You may need to install dependencies manually"
        exit 1
    fi

    cd ~
    print_step "Paru installed successfully!"
else
    print_info "Paru is already installed"
fi

echo ""
print_step "Installing Peitharchy AUR packages..."
echo ""

# Track what gets installed
INSTALLED=()
FAILED=()

# Install xcursor-breeze
print_info "Installing xcursor-breeze (Breeze cursor theme)..."
if paru -S --needed --noconfirm xcursor-breeze; then
    INSTALLED+=("xcursor-breeze")
    print_info "✓ xcursor-breeze installed"
else
    FAILED+=("xcursor-breeze")
    print_warning "✗ Failed to install xcursor-breeze"
fi

echo ""

# Install ghostty
print_info "Installing ghostty (Terminal emulator)..."
print_warning "Note: ghostty may take several minutes to compile"
if paru -S --needed --noconfirm ghostty; then
    INSTALLED+=("ghostty")
    print_info "✓ ghostty installed"
else
    FAILED+=("ghostty")
    print_warning "✗ Failed to install ghostty"
fi

echo ""

# Install greetd-tuigreet from AUR (as replacement for official package)
print_info "Installing greetd-tuigreet from AUR..."
if paru -S --needed --noconfirm greetd-tuigreet; then
    INSTALLED+=("greetd-tuigreet")
    print_info "✓ greetd-tuigreet installed from AUR"
else
    FAILED+=("greetd-tuigreet")
    print_warning "✗ Failed to install greetd-tuigreet from AUR"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_step "Installation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ${#INSTALLED[@]} -gt 0 ]; then
    print_info "Successfully installed:"
    for pkg in "${INSTALLED[@]}"; do
        echo "  ✓ $pkg"
    done
    echo ""
fi

if [ ${#FAILED[@]} -gt 0 ]; then
    print_warning "Failed to install:"
    for pkg in "${FAILED[@]}"; do
        echo "  ✗ $pkg"
    done
    echo ""
    print_info "You can try installing failed packages manually:"
    for pkg in "${FAILED[@]}"; do
        echo "  paru -S $pkg"
    done
    echo ""
fi

# Configure cursor if xcursor-breeze was installed
if [[ " ${INSTALLED[@]} " =~ " xcursor-breeze " ]]; then
    print_step "Configuring Breeze cursor..."
    if command -v hyprctl &> /dev/null; then
        hyprctl setcursor Breeze 24 2>/dev/null || true
        print_info "Cursor set to Breeze (size 24)"
    fi
fi

# Configure ghostty if installed
if [[ " ${INSTALLED[@]} " =~ " ghostty " ]]; then
    print_info "Ghostty terminal installed"
    print_info "You can launch it with: ghostty"
    print_info "Or set it as default in ~/.config/hypr/programs.conf"
fi

echo ""
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ${#FAILED[@]} -eq 0 ]; then
    print_step "All AUR packages installed successfully!"
else
    print_warning "Some packages failed to install, but this is OK"
    print_info "Peitharchy will work fine with the official repository packages"
fi

echo ""
print_info "Alternatives to AUR packages:"
echo "  - Cursor themes: sudo pacman -S xcursor-themes"
echo "  - Terminal: kitty, alacritty (already installed)"
echo ""
