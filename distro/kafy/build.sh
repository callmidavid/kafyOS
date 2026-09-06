#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "=========================================="
echo "         Kafy OS Local ISO Builder        "
echo "=========================================="

# 1. Check host dependencies
./check-host

# 2. Patch Ubuntu live-build gfxboot bug if present on host
if [ -f /usr/lib/live/build/lb_binary_syslinux ]; then
  if grep -q '(cd "$tmpdir" && cpio -i) < ${_TARGET}/bootlogo' /usr/lib/live/build/lb_binary_syslinux; then
    echo "Applying compatibility patch to host live-build..."
    sudo python3 -c '
path = "/usr/lib/live/build/lb_binary_syslinux"
with open(path, "r") as f:
    text = f.read()

old_1 = "(cd \"$tmpdir\" && cpio -i) < ${_TARGET}/bootlogo"
new_1 = "[ -e \"${_TARGET}/bootlogo\" ] && (cd \"$tmpdir\" && cpio -i) < ${_TARGET}/bootlogo || true"

old_2 = "(cd \"$tmpdir\" && ls -1 | cpio --quiet -o) > ${_TARGET}/bootlogo"
new_2 = "[ -e \"${_TARGET}/bootlogo\" ] && (cd \"$tmpdir\" && ls -1 | cpio --quiet -o) > ${_TARGET}/bootlogo || true"

text = text.replace(old_1, new_1).replace(old_2, new_2)
with open(path, "w") as f:
    f.write(text)
print("Host live-build patched successfully.")
'
  fi
fi

# 3. Prepare bootloader binaries
echo "Preparing bootloader binaries..."
mkdir -p config/bootloaders/isolinux
mkdir -p config/includes.chroot/usr/lib/syslinux

ISOLINUX_BIN=$(find /usr -name isolinux.bin 2>/dev/null | grep -v "/live/build" | head -n 1 || true)
VESAMENU_C32=$(find /usr -name vesamenu.c32 2>/dev/null | grep -v "/live/build" | head -n 1 || true)
LDLINUX_C32=$(find /usr -name ldlinux.c32 2>/dev/null | head -n 1 || true)
LIBUTIL_C32=$(find /usr -name libutil.c32 2>/dev/null | head -n 1 || true)
LIBCOM32_C32=$(find /usr -name libcom32.c32 2>/dev/null | head -n 1 || true)

if [ -n "$ISOLINUX_BIN" ] && [ -n "$VESAMENU_C32" ]; then
  cp -f "$ISOLINUX_BIN" config/bootloaders/isolinux/isolinux.bin
  cp -f "$VESAMENU_C32" config/bootloaders/isolinux/vesamenu.c32
  [ -n "$LDLINUX_C32" ] && cp -f "$LDLINUX_C32" config/bootloaders/isolinux/ldlinux.c32 || true
  [ -n "$LIBUTIL_C32" ] && cp -f "$LIBUTIL_C32" config/bootloaders/isolinux/libutil.c32 || true
  [ -n "$LIBCOM32_C32" ] && cp -f "$LIBCOM32_C32" config/bootloaders/isolinux/libcom32.c32 || true

  cp -f "$ISOLINUX_BIN" config/includes.chroot/usr/lib/syslinux/isolinux.bin
  cp -f "$VESAMENU_C32" config/includes.chroot/usr/lib/syslinux/vesamenu.c32
  [ -n "$LDLINUX_C32" ] && cp -f "$LDLINUX_C32" config/includes.chroot/usr/lib/syslinux/ldlinux.c32 || true
  [ -n "$LIBUTIL_C32" ] && cp -f "$LIBUTIL_C32" config/includes.chroot/usr/lib/syslinux/libutil.c32 || true
  [ -n "$LIBCOM32_C32" ] && cp -f "$LIBCOM32_C32" config/includes.chroot/usr/lib/syslinux/libcom32.c32 || true
fi

# 4. Clean previous build artifacts and unmount stale chroots
echo "Cleaning build environment..."
sudo umount -lf chroot/dev/pts 2>/dev/null || true
sudo umount -lf chroot/dev 2>/dev/null || true
sudo umount -lf chroot/proc 2>/dev/null || true
sudo umount -lf chroot/sys 2>/dev/null || true
sudo lb clean --purge

# 5. Configure live-build
echo "Configuring Kafy OS live-build..."
sudo ./auto/config

# 6. Build ISO
echo "Starting ISO build..."
sudo lb build

# 7. Finalize output
ISO_FILE=$(ls *.iso 2>/dev/null | head -n 1 || true)
if [ -n "$ISO_FILE" ]; then
  if [ "$ISO_FILE" != "kafy-os.iso" ]; then
    mv "$ISO_FILE" kafy-os.iso
  fi
  sha256sum kafy-os.iso > kafy-os.iso.sha256
  echo "=========================================="
  echo "       BUILD SUCCESSFUL! ISO CREATED      "
  echo "=========================================="
  ls -lh kafy-os.iso
  echo "Checksum: $(cat kafy-os.iso.sha256)"
else
  echo "Error: ISO was not created."
  exit 1
fi

