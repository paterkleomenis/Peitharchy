# Peitharchy — Arch Linux Hyprland Setup (Corrected Package List)

This README contains the clean, up-to-date package list for the current Hyprland setup on Arch Linux. It includes the exact install command, deduplicated and reflecting everything currently in use.

Use --needed to avoid reinstalling packages you already have.

## Exact install command

```
sudo pacman -S --needed \
  hyprland hyprpaper hypridle hyprlock hyprshot hyprsunset \
  waybar rofi cliphist wl-clipboard libnotify \
  polkit-gnome xdg-desktop-portal-hyprland xdg-desktop-portal-gtk swaync \
  playerctl jq grim slurp \
  nautilus network-manager-applet blueman \
  gnome-keyring libsecret polkit gcr \
  greetd greetd-tuigreet flameshot \
  wireplumber pavucontrol alsa-utils \
  gst-plugins-good gst-plugins-bad gst-plugins-ugly  \
  kdeconnect \
  neovim nano curl wget unzip p7zip tar base-devel git \
  ttf-jetbrains-mono-nerd inter-font \
  noto-fonts noto-fonts-cjk noto-fonts-emoji \
  gnome-system-monitor baobab pipewire pipewire-alsa pipewire-pulse pipewire-jack
```

## Install AUR helper (paru)

```
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

## Install AUR packages

```
paru -S xcursor-breeze
```

## Install Flatpak

```
sudo pacman -S --needed flatpak
```

Add Flathub (required for most apps, including MissionCenter):

```
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## Install MissionCenter (Flatpak)

```
flatpak install io.missioncenter.MissionCenter
```

## Package overview

- Hyprland core:
  - hyprland, hyprpaper, hypridle, hyprlock, hyprshot, hyprsunset
- Bar, launcher, notifications, clipboard:
  - waybar, rofi, swaync, cliphist, wl-clipboard, libnotify
- Portals and polkit agent:
  - xdg-desktop-portal-hyprland, xdg-desktop-portal-gtk, polkit-gnome
- Utilities:
  - playerctl, jq, grim, slurp
- File/app and connectivity:
  - nautilus, network-manager-applet, blueman, kdeconnect
- Keyring and polkit base:
  - gnome-keyring, libsecret, polkit, gcr
- Login manager:
  - greetd, greetd-tuigreet
- Screenshots:
  - flameshot
- Audio stack:
  - wireplumber, pavucontrol, alsa-utils,
  - gst-plugins-good, gst-plugins-bad, gst-plugins-ugly
- Editors/CLI:
  - neovim, nano, curl, wget, unzip, p7zip, tar, base-devel, git
- Fonts:
  - ttf-jetbrains-mono-nerd, inter-font,
  - noto-fonts, noto-fonts-cjk, noto-fonts-emoji
- GNOME utilities:
  - gnome-system-monitor, baobab

Removed compared to previous iterations: brightnessctl, zip, htop, btop, file-roller, gst-libav.
AUR packages: xcursor-breeze (install via paru).

## Post-install notes

- Enable greetd (tuigreet):
  - sudo systemctl enable greetd
- If you use another display manager (GDM/SDDM/LightDM), disable it before enabling greetd.
- polkit-gnome and gnome-keyring can be launched via your Hyprland config using exec-once lines.
- Ensure you’re on PipeWire; if not, also install: pipewire, pipewire-alsa, pipewire-pulse, pipewire-jack.
# Peitharchy
