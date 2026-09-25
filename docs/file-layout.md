# File Layout

Kafy separates its product source from its bootable Arch image builder.

## Mental model

`kafy-iso/` is the separate Archiso builder repository. It constructs the live ISO from an explicit package list and boot configuration, then composes this repository's product source into a temporary profile. Its profile has no duplicate Kafy desktop configuration.

`config/` is the canonical source for static user and system configuration. `default/` holds Kafy-owned assets and templates. `bin/` holds Kafy commands. `install/` owns installation and first-run setup. The ISO builder composes these source trees into a generated Archiso profile; it does not maintain another product-config copy.

`docs/debian-live-build-explained.md` records the former Debian implementation. It is historical reference only and must not be treated as an active build path.

`manual/` is end-user documentation. It explains what someone can do in Kafy and must not expose unfinished implementation as completed product behavior.

`docs/` is contributor documentation. It explains source layout, architecture, build behavior, validation, and design decisions.

## Source and ISO boundary

| Path | Responsibility |
| --- | --- |
| `config/` | Kafy static defaults, including `/etc/skel` user configuration. |
| `default/` | Kafy-owned assets, branding, and future templates. |
| `bin/` | User-facing Kafy commands. |
| `install/live/` | Live-session setup and installer entry points. |
| `../kafy-iso/archiso/` | ISO metadata, package list, Archiso-only live files, and boot configuration. |
| `../kafy-iso/archiso/prepare-profile.sh` | The declared composition boundary between source and ISO. |
| `../kafy-iso/test/` | ISO composition and boot/install acceptance tests. |

## Configuration ownership

The live account and each new account receive Hyprland, Hyprpaper, Hyprlock, and Waybar defaults from `config/etc/skel`. A Kafy update must not silently overwrite an existing person's home-directory configuration. New defaults belong in `config/`; migrations and explicit reset behavior belong in `migrations/` and `bin/`.

## Build output

`kafy-iso/out/`, `kafy-iso/work/`, and `kafy-iso/cache/` are generated build state. They are not source files and must not be committed. The ISO and SHA-256 checksum are the release artifacts.
