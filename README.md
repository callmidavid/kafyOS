# Kafy OS

Kafy is an Arch-based desktop Linux distribution focused on a polished macOS-like experience, zero-setup defaults, and gaming readiness.

## Documentation

- Read the [Kafy Manual](manual/README.md) to try the current live ISO and learn the desktop.
- Read the [technical documentation](docs/README.md) to build, test, and contribute to Kafy.

The current source of truth is the Arch `archiso` profile in `distro/kafy`. The former Debian live-build profile is preserved in `distro/kafy-deb` for reference. Older Rust desktop experiments are not part of the first OS image path.

## Build Direction

- Base: Arch Linux
- Image system: archiso
- Desktop baseline: Hyprland while Kafy desktop components mature
- Gaming baseline: Steam installer, Proton support, GameMode, MangoHud, Vulkan tooling, controller support, Wine/Lutris, and Flatpak-based gaming apps
- App model: Flatpak and Flathub enabled by default
- Future compositor: Smithay-based Wayland compositor when the Kafy shell is ready

## Build An ISO

Install build dependencies on an Arch host:

```sh
sudo pacman -Syu --needed archiso
```

Build:

```sh
cd distro/kafy
./check-host
sudo ./build.sh
```

The generated ISO appears in `distro/kafy` when the build completes.

If `./auto/config` says `lb: not found`, install `live-build`. `lb` is not built into Debian or Ubuntu; it is the command installed by the `live-build` package.

## How This Works

Arch is made of packages managed by `pacman`. An Arch-based distro like Kafy starts from the Arch repositories, chooses packages, adds defaults and branding, then builds an installable/live image.

`archiso` is Arch's image builder. It reads the files in `distro/kafy`, creates a temporary Arch filesystem, installs the package list, copies Kafy files into it, and compresses it into a bootable ISO.

Read [distro/kafy/README.md](distro/kafy/README.md) for the profile layout and local build steps, then follow the [ISO build and test checklist](docs/iso-build-and-test.md) before calling an image ready.

## Product Rule

Kafy should boot into a usable desktop without making users learn Linux setup chores. Driver handling, app sources, gaming tooling, multimedia, power management, and common hardware support belong in the image defaults.
