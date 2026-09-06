# Kafy Live Profile

This directory is the first real Kafy OS build profile. It uses Debian live-build to produce a bootable Debian-based ISO with Kafy defaults.

## Files

- `build.sh`: One-command automated local build script.
- `check-host`: Verifies required build tools on the host system.
- `auto/config`: live-build image configuration.
- `config/package-lists/*.list.chroot`: packages installed into the OS.
- `config/includes.chroot/`: files copied into the target filesystem.
- `config/hooks/*.chroot`: build hooks run inside the target chroot.
- `config/bootloaders/isolinux/`: custom hybrid bootloader templates.
- `config/archives/`: extra apt source definitions.

## Local Build Instructions

### 1. Install Host Dependencies

On Debian or Ubuntu hosts:

```sh
sudo apt update
sudo apt install -y live-build live-config live-boot debootstrap xorriso squashfs-tools \
  isolinux syslinux syslinux-common syslinux-utils mtools dosfstools librsvg2-bin \
  grub-efi-amd64-bin grub-pc-bin
```

### 2. Run the Build

Run the automated build script:

```sh
cd distro/kafy
./build.sh
```

The script will automatically:

1. Verify host dependencies via `./check-host`.
2. Apply the compatibility fix for Ubuntu's `live-build` gfxboot bug.
3. Prepare bootloader binaries (`isolinux.bin`, `vesamenu.c32`, etc.).
4. Safely unmount any stale chroot mounts and clean previous build files.
5. Configure `live-build` and compile the bootable ISO.
6. Generate `kafy-os.iso` and `kafy-os.iso.sha256`.

## Cloud Build (GitHub Actions)

You can also trigger a cloud build anytime:

1. Go to your repository on GitHub -> **Actions** tab.
2. Select **Build Kafy OS ISO** -> **Run workflow**.
3. Download the finished ISO directly from GitHub Actions artifacts.
