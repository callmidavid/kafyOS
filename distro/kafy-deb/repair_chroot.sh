#!/bin/bash
# Kafy OS Chroot Repair Script
set -e

# Ensure we are in the distro/kafy directory
if [ ! -d "chroot" ]; then
    echo "Error: Please run this script from the distro/kafy/ directory."
    exit 1
fi

echo "Cleaning up any stale dpkg lock files..."
sudo rm -f chroot/var/lib/dpkg/lock
sudo rm -f chroot/var/lib/dpkg/lock-frontend
sudo rm -f chroot/var/lib/apt/lists/lock

echo "Mounting system filesystems to the chroot..."
sudo mount --bind /dev chroot/dev
sudo mount --bind /dev/pts chroot/dev/pts
sudo mount --bind /proc chroot/proc
sudo mount --bind /sys chroot/sys

# Trap to guarantee unmounting even if command fails
cleanup() {
    echo "Unmounting filesystems..."
    sudo umount -lf chroot/dev/pts 2>/dev/null || true
    sudo umount -lf chroot/dev 2>/dev/null || true
    sudo umount -lf chroot/proc 2>/dev/null || true
    sudo umount -lf chroot/sys 2>/dev/null || true
}
trap cleanup EXIT

echo "Running configuration repair inside the chroot..."
sudo chroot chroot dpkg --configure -a

echo "Repair complete! You can now run 'sudo lb build' to resume the ISO build."
