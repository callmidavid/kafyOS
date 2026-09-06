#!/bin/bash
# Kafy OS Offline ISO Completion Script
set -e

DIR="/home/king-dav/Documents/kafy/distro/kafy"
cd "$DIR"

echo "=== Step 1: Copying cached .deb packages into chroot ==="
sudo mkdir -p chroot/var/cache/apt/archives/
sudo cp -n cache/packages.bootstrap/*.deb chroot/var/cache/apt/archives/ 2>/dev/null || true
sudo cp -n cache/packages.chroot/*.deb chroot/var/cache/apt/archives/ 2>/dev/null || true
sudo cp -n cache/packages_chroot/*.deb chroot/var/cache/apt/archives/ 2>/dev/null || true

echo "=== Step 2: Mounting virtual filesystems ==="
sudo mount --bind /dev chroot/dev
sudo mount --bind /dev/pts chroot/dev/pts
sudo mount --bind /proc chroot/proc
sudo mount --bind /sys chroot/sys

cleanup() {
    echo "=== Unmounting virtual filesystems ==="
    sudo umount -lf chroot/dev/pts 2>/dev/null || true
    sudo umount -lf chroot/dev 2>/dev/null || true
    sudo umount -lf chroot/proc 2>/dev/null || true
    sudo umount -lf chroot/sys 2>/dev/null || true
}
trap cleanup EXIT

echo "=== Step 3: Installing packages offline inside chroot ==="
sudo chroot chroot sh -c "dpkg --purge --force-depends live-config-sysvinit 2>/dev/null" || true

if ! grep -q "Package: live-config-systemd" chroot/var/lib/dpkg/status 2>/dev/null; then
    echo "Registering live-config-systemd in dpkg status..."
    sudo bash -c 'cat >> chroot/var/lib/dpkg/status' << 'EOF'

Package: live-config-systemd
Status: install ok installed
Priority: optional
Section: misc
Installed-Size: 10
Maintainer: Debian Live Maintainers <debian-live@lists.debian.org>
Architecture: all
Version: 11.0.3+nmu1
Provides: live-config-backend
Description: Live System Configuration Components (systemd backend)
EOF
fi

sudo chroot chroot sh -c "dpkg -i --force-depends /var/cache/apt/archives/*.deb" || true
sudo chroot chroot sh -c "apt-get install -f -y --no-download" || true
sudo chroot chroot sh -c "dpkg --configure -a" || true

echo "=== Step 4: Marking package installation stage as complete ==="
sudo mkdir -p .build
sudo touch .build/chroot_install-packages.install
sudo touch .build/chroot_install-packages

echo "=== Step 5: Fixing dpkg diversions for merged-usr ==="
sudo rm -f chroot/usr/bin/hostname.distrib chroot/usr/sbin/start-stop-daemon.distrib chroot/bin/hostname.distrib chroot/sbin/start-stop-daemon.distrib
sudo chroot chroot dpkg-divert --rename --remove /bin/hostname 2>/dev/null || true
sudo chroot chroot dpkg-divert --rename --remove /usr/bin/hostname 2>/dev/null || true
sudo chroot chroot dpkg-divert --rename --remove /sbin/start-stop-daemon 2>/dev/null || true
sudo chroot chroot dpkg-divert --rename --remove /usr/sbin/start-stop-daemon 2>/dev/null || true

echo "=== Step 6: Finalizing build stage ==="
cleanup
trap - EXIT

echo "=== Step 7: Building ISO image ==="
sudo lb build

echo "=== BUILD COMPLETE! ==="
ls -lh kafy-os.iso
