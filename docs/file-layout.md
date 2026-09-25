# File Layout

Kafy separates the bootable Arch image from its user documentation and technical reference.

## Mental model

`distro/kafy/` is the active Archiso profile. It constructs the live ISO from an explicit package list, boot configuration, and files copied into the live root filesystem.

`distro/kafy-deb/` is the preserved Debian implementation. It is historical reference only and must not be changed when working on the active image.

`manual/` is end-user documentation. It explains what someone can do in Kafy and must not expose unfinished implementation as completed product behavior.

`docs/` is contributor documentation. It explains source layout, architecture, build behavior, validation, and design decisions.

## Active ISO profile

| Path | Responsibility |
| --- | --- |
| `distro/kafy/profiledef.sh` | ISO identity, architecture, compression, and BIOS/UEFI boot modes. |
| `distro/kafy/pacman.conf` | Official Arch repositories used at build time. |
| `distro/kafy/packages.x86_64` | Explicit packages in the live image. |
| `distro/kafy/syslinux/` | BIOS boot menu configuration. |
| `distro/kafy/efiboot/` | UEFI systemd-boot configuration. |
| `distro/kafy/airootfs/` | Files copied into the ISO root filesystem. |
| `distro/kafy/airootfs/etc/skel/` | Default configuration copied to each newly created user. |
| `distro/kafy/airootfs/usr/local/bin/` | Kafy-owned runtime scripts, including the welcome flow and installer. |

## Configuration ownership

The live account and each new account receive Hyprland, Hyprpaper, Hyprlock, and Waybar defaults from `/etc/skel`. A Kafy update must not silently overwrite an existing person's home-directory configuration. New defaults should be versioned in the image or future Kafy package, while migrations must be explicit and reversible.

## Build output

`distro/kafy/out/`, `distro/kafy/work/`, and `distro/kafy/cache/` are generated build state. They are not source files and must not be committed. The ISO and SHA-256 checksum are the release artifacts.
