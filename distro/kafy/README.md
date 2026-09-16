# Kafy Arch ISO Profile

This is the active Kafy OS image profile. It uses Arch Linux's `archiso` to build a current, small, bootable Hyprland desktop.

Kafy deliberately keeps the desktop explicit rather than installing a broad desktop meta-package. Step 1 provides a polished Hyprland baseline with a top bar, application launcher, gentle motion, and hardware support. The dock, control center, installer flow, and Kafy shell are added only after this image boots reliably.

The previous Debian implementation is preserved at `../kafy-deb`.

## Build locally

On an Arch Linux or Arch-based host:

```sh
sudo pacman -Syu --needed archiso
cd distro/kafy
sudo ./build.sh
```

The ISO and its SHA-256 checksum are written to `distro/kafy/out/`.

On Ubuntu or Debian, install Docker and build through the included Arch container:

```sh
sudo apt update
sudo apt install -y docker.io
sudo ./build.sh
```

Do not run `pacman` directly on Ubuntu or Debian; it is Arch's package manager. The build script selects the Docker path automatically when `mkarchiso` is not installed.

## Profile layout

- `packages.x86_64`: exact packages installed in the image.
- `airootfs/`: Kafy files copied into the live system.
- `profiledef.sh`: ISO metadata, architecture, boot modes, and compression settings.
- `pacman.conf`: Arch repositories used during the image build; `multilib` is enabled for Steam and 32-bit graphics support.

The live image signs in automatically as `liveuser` so it opens straight to the desktop. The installer remains an explicit application; an installed system must create its own user and must not inherit the live-session autologin configuration.
