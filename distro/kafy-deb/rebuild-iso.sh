#!/bin/bash
set -e
DIR="/home/king-dav/Documents/kafy/distro/kafy"
cd "$DIR"

BINARY_DIR="chroot/binary"
if [ ! -f "$BINARY_DIR/live/filesystem.squashfs" ]; then
    echo "ERROR: filesystem.squashfs not found in $BINARY_DIR/live/"
    exit 1
fi

echo "=== Setting up bootloader ==="

mkdir -p "$BINARY_DIR/boot/grub" "$BINARY_DIR/live"
# Clean up any previous EFI directory that might conflict
rm -rf "$BINARY_DIR/EFI" "$BINARY_DIR/grub" "$BINARY_DIR/boot/grub/efi.img"

cp chroot/boot/vmlinuz-* "$BINARY_DIR/live/vmlinuz" 2>/dev/null || cp chroot/vmlinuz "$BINARY_DIR/live/vmlinuz"
cp chroot/boot/initrd.img-* "$BINARY_DIR/live/initrd.img" 2>/dev/null || cp chroot/initrd.img "$BINARY_DIR/live/initrd.img"
echo "Copied kernel and initrd"

cat > /tmp/grub.cfg << 'GRUB'
set default=0
set timeout=10
insmod iso9660
insmod part_msdos
insmod part_gpt
search --set=root --label KAFY_OS
menuentry "Kafy OS" {
    linux /live/vmlinuz boot=live components quiet splash
    initrd /live/initrd.img
}
GRUB

echo "=== Building standalone UEFI binary ==="
grub-mkstandalone -O x86_64-efi \
    --modules="iso9660 fat part_msdos part_gpt normal boot linux configfile loopback chain search search_fs_file search_fs_uuid search_label efi_gop efi_uga all_video gfxterm font video" \
    -o /tmp/BOOTx64.EFI \
    "boot/grub/grub.cfg=/tmp/grub.cfg"

echo "=== Building UEFI FAT image ==="
EFI_IMG="$BINARY_DIR/boot/grub/efi.img"
rm -f "$EFI_IMG"

dd if=/dev/zero of="$EFI_IMG" bs=1M count=20 2>/dev/null
mkfs.fat -F 16 -n "KAFY_EFI" "$EFI_IMG" > /dev/null 2>&1

MNT=$(mktemp -d)
mount -o loop "$EFI_IMG" "$MNT"
mkdir -p "$MNT/EFI/BOOT"
cp /tmp/BOOTx64.EFI "$MNT/EFI/BOOT/BOOTx64.EFI"
umount "$MNT"
rmdir "$MNT"
rm -f /tmp/BOOTx64.EFI /tmp/grub.cfg
echo "UEFI boot image created"

echo "=== Building ISO ==="
rm -f kafy-os.iso

chroot chroot /usr/bin/genisoimage \
    -J -l -allow-limited-size \
    -A "Kafy OS" \
    -p "live-build 3.0~a57-1" \
    -publisher "Kafy Project" \
    -V "KAFY_OS" \
    --efi-boot boot/grub/efi.img \
    -no-emul-boot \
    -o /kafy-os.iso /binary 2>&1

# Move ISO from chroot to current dir
mv chroot/kafy-os.iso kafy-os.iso 2>/dev/null || true

echo "=== Done ==="
ls -lh kafy-os.iso
