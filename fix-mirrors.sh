#!/bin/bash

# Peitharchy Mirror Fix Script
# Fixes common pacman mirror and keyring issues

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
print_step "Peitharchy Mirror Fix Script"
echo ""
print_info "This script will help fix common pacman mirror issues"
echo ""

# Step 1: Test network connectivity
print_step "Testing network connectivity..."
if ping -c 3 archlinux.org &> /dev/null; then
    print_info "Network connection is working"
else
    print_error "Cannot reach archlinux.org"
    print_warning "Please check your internet connection"
    exit 1
fi

# Step 2: Update keyring
print_step "Updating Arch Linux keyring..."
if sudo pacman -Sy --noconfirm archlinux-keyring; then
    print_info "Keyring updated successfully"
else
    print_warning "Failed to update keyring, but continuing..."
fi

# Step 3: Check if reflector is installed
print_step "Checking for reflector..."
if ! command -v reflector &> /dev/null; then
    print_info "Installing reflector..."
    sudo pacman -S --noconfirm reflector
fi

# Step 4: Backup current mirrorlist
print_step "Backing up current mirrorlist..."
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
print_info "Backup created at /etc/pacman.d/mirrorlist.backup"

# Step 5: Ask user for country preference
echo ""
print_info "Select mirror location preference:"
echo "  1. Worldwide (fastest 20 mirrors)"
echo "  2. Europe only"
echo "  3. Greece only"
echo "  4. United States only"
echo "  5. Custom country"
echo ""
read -p "Enter choice [1]: " mirror_choice
mirror_choice=${mirror_choice:-1}

case $mirror_choice in
    1)
        print_step "Fetching fastest 20 mirrors worldwide..."
        sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
        ;;
    2)
        print_step "Fetching fastest mirrors in Europe..."
        sudo reflector --country France,Germany,Netherlands,Sweden,UK --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
        ;;
    3)
        print_step "Fetching mirrors in Greece..."
        sudo reflector --country Greece --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
        ;;
    4)
        print_step "Fetching mirrors in United States..."
        sudo reflector --country US --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
        ;;
    5)
        read -p "Enter country name (e.g., Greece, Germany): " country
        print_step "Fetching mirrors in $country..."
        sudo reflector --country "$country" --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist || {
            print_error "Failed to fetch mirrors for $country"
            print_info "Falling back to worldwide mirrors..."
            sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
        }
        ;;
    *)
        print_step "Using default worldwide mirrors..."
        sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
        ;;
esac

print_info "New mirrorlist generated"

# Step 6: Show top 3 mirrors
echo ""
print_info "Top 3 mirrors selected:"
head -n 10 /etc/pacman.d/mirrorlist | grep "^Server" | head -n 3

# Step 7: Sync and update
echo ""
print_step "Syncing package databases..."
sudo pacman -Syy

echo ""
print_step "Testing package installation..."
if sudo pacman -S --noconfirm --needed base-devel; then
    print_info "Package installation test successful"
else
    print_error "Still having issues with package installation"
    print_warning "You may need to:"
    echo "  1. Check your firewall settings"
    echo "  2. Try a different network connection"
    echo "  3. Manually edit /etc/pacman.d/mirrorlist"
    exit 1
fi

echo ""
print_step "Mirror fix complete!"
echo ""
print_info "Your mirrorlist has been updated and tested"
print_info "You can now run the Peitharchy install script"
echo ""
print_info "If issues persist, restore backup with:"
echo "  sudo cp /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist"
echo ""
