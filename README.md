# Kafy OS

Kafy is an Arch-based desktop Linux distribution focused on a polished macOS-like experience, zero-setup defaults, and gaming readiness.

## Documentation

- Read the [Kafy Manual](manual/README.md) to try the current live ISO and learn the desktop.
- Read the [technical documentation](docs/README.md) to contribute to Kafy.

This repository is Kafy's product source: desktop configuration, assets, commands, installation logic, shell, and documentation. ISO construction is isolated in the sibling `kafy-iso` repository, following Omarchy's source/ISO separation. The former Debian live-build effort is retained only as historical documentation.

## Build Direction

- Base: Arch Linux
- Image system: archiso
- Desktop baseline: Hyprland while Kafy desktop components mature
- Gaming baseline: Steam installer, Proton support, GameMode, MangoHud, Vulkan tooling, controller support, Wine/Lutris, and Flatpak-based gaming apps
- App model: Flatpak and Flathub enabled by default
- Future compositor: Smithay-based Wayland compositor when the Kafy shell is ready

## Build an ISO

Clone Kafy beside its ISO builder, then build from the builder repository:

```sh
cd ~/Documents/kafy-iso/archiso
sudo ./build.sh
```

The builder reads `~/Documents/kafy` by default and writes the result to `~/Documents/kafy-iso/out/`. For another checkout, set `KAFY_SOURCE`:

```sh
sudo env KAFY_SOURCE=/path/to/kafy ./build.sh
```

Run its fast composition check first:

```sh
cd ~/Documents/kafy-iso
./test/unit/profile-composition.sh
```

## How This Works

Arch is made of packages managed by `pacman`. An Arch-based distro like Kafy starts from the Arch repositories, chooses packages, adds defaults and branding, then builds an installable/live image.

`archiso` is Arch's image builder. The separate `kafy-iso` repository creates a temporary Arch filesystem, installs the package list, composes this repository's product sources into it, and compresses it into a bootable ISO.

Read the [Kafy ISO builder guide](../kafy-iso/docs/iso-build-and-test.md) for build and VM-test requirements before calling an image ready.

## Product Rule

Kafy should boot into a usable desktop without making users learn Linux setup chores. Driver handling, app sources, gaming tooling, multimedia, power management, and common hardware support belong in the image defaults.
