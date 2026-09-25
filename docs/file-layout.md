# File Layout

Kafy separates the bootable Arch image from its user documentation and technical reference.

## Mental model

`distro/kafy/` is the active Archiso assembly profile. It constructs the live ISO from an explicit package list, boot configuration, and a temporary profile composed from Kafy source trees.

`config/` is the canonical source for static user and system configuration. `default/` holds Kafy-owned assets and templates. `bin/` holds Kafy commands. `install/` owns installation and first-run setup. The ISO builder composes these source trees into a generated Archiso profile; it does not maintain another product-config copy.

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
| `distro/kafy/airootfs/` | Archiso-only files, including live initramfs configuration. |
| `distro/kafy/prepare-profile.sh` | Creates the temporary Archiso profile and composes Kafy source trees. |
| `config/` | Kafy static defaults, including `/etc/skel` user configuration. |
| `default/` | Kafy-owned assets, branding, and future templates. |
| `bin/` | User-facing Kafy commands. |
| `install/live/` | Live-session setup and the experimental installer. |

## Configuration ownership

The live account and each new account receive Hyprland, Hyprpaper, Hyprlock, and Waybar defaults from `config/etc/skel`. A Kafy update must not silently overwrite an existing person's home-directory configuration. New defaults belong in `config/`; migrations and explicit reset behavior belong in `migrations/` and `bin/`.

## Build output

`distro/kafy/out/`, `distro/kafy/work/`, and `distro/kafy/cache/` are generated build state. They are not source files and must not be committed. The ISO and SHA-256 checksum are the release artifacts.
