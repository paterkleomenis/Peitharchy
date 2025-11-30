#!/usr/bin/env bash

# Detect GPU and generate Hyprland environment variables
# This script is called during installation to set up hardware acceleration

OUTPUT_FILE="$HOME/.config/hypr/gpu.conf"
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Clear existing file
echo "# Auto-generated GPU configuration" > "$OUTPUT_FILE"

# Detect GPU
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq "nvidia"; then
    echo "Detected GPU: NVIDIA"
    {
        echo "env = LIBVA_DRIVER_NAME,nvidia"
        echo "env = XDG_SESSION_TYPE,wayland"
        echo "env = GBM_BACKEND,nvidia-drm"
        echo "env = __GLX_VENDOR_LIBRARY_NAME,nvidia"
        echo "env = NVD_BACKEND,direct"
        echo "cursor {"
        echo "    no_hardware_cursors = true"
        echo "}"
    } >> "$OUTPUT_FILE"

elif lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq "amd"; then
    echo "Detected GPU: AMD"
    {
        echo "env = LIBVA_DRIVER_NAME,radeonsi"
        echo "env = VDPAU_DRIVER,radeonsi"
    } >> "$OUTPUT_FILE"

elif lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq "intel"; then
    echo "Detected GPU: Intel"
    {
        echo "env = LIBVA_DRIVER_NAME,iHD"
    } >> "$OUTPUT_FILE"

else
    echo "No specific GPU configuration found. Using defaults."
    echo "# No specific GPU envs needed" >> "$OUTPUT_FILE"
fi

echo "GPU configuration written to $OUTPUT_FILE"
