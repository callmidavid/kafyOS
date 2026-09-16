# Kafy Arch ISO Profile

This is the active Kafy OS image profile. It uses Arch Linux's `archiso` to build a current, small, bootable KDE Plasma Wayland desktop.

Kafy deliberately keeps the desktop explicit rather than installing a broad desktop meta-package. The default session provides a macOS-inspired top bar and floating dock, a global menu, gentle motion settings, Flatpak/Discover, and hardware and gaming support without asking ordinary users to use the terminal.

The previous Debian implementation is preserved at `../kafy-deb`.

## Build locally

Build on an Arch Linux or Arch-based host:

```sh
sudo pacman -Syu --needed archiso
cd distro/kafy
sudo ./build.sh
```

The ISO and its SHA-256 checksum are written to `distro/kafy/out/`.

## Profile layout

- `packages.x86_64`: exact packages installed in the image.
- `airootfs/`: Kafy files copied into the live system.
- `profiledef.sh`: ISO metadata, architecture, boot modes, and compression settings.
- `pacman.conf`: Arch repositories used during the image build; `multilib` is enabled for Steam and 32-bit graphics support.

The live image signs in automatically as `liveuser` so it opens straight to the desktop. The installer remains an explicit application; an installed system must create its own user and must not inherit the live-session autologin configuration.
