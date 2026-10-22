#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
installer="$project_dir/install/live/usr/local/bin/kafy-installer"
welcome="$project_dir/install/live/usr/local/bin/kafy-welcome"
backend="$project_dir/install/live/usr/local/lib/kafy/install/kafy-install-backend"
desktop="$project_dir/install/live/usr/share/applications/kafy-installer.desktop"
payload="$project_dir/install/live/usr/local/share/kafy-installer"
fallback="$project_dir/install/live/usr/local/bin/kafy-install-target"
provisioner="$project_dir/install/system/usr/local/lib/kafy/install/provision-target"
first_boot="$project_dir/install/system/usr/local/bin/kafy-first-boot"
first_boot_unit="$project_dir/install/system/etc/systemd/user/kafy-first-boot.service"

# The front-end is a GTK4/libadwaita application and hands work to the root
# backend. It must not fall back to a terminal TUI.
rg -Fq 'gi.require_version("Gtk", "4.0")' "$installer"
rg -Fq 'gi.require_version("Adw", "1")' "$installer"
rg -Fq 'kafy-install-backend' "$installer"
rg -Fq 'Adw.Application' "$installer"

# The backend owns disk setup, the package install, target configuration,
# Kafy provisioning, and the bootloader.
for needle in sgdisk pacstrap genfstab arch-chroot chpasswd provision-target bootctl grub-install; do
  rg -Fq "$needle" "$backend" || {
    printf 'Installer backend is missing: %s\n' "$needle" >&2
    exit 1
  }
done

# One canonical target package list plus opt-in groups.
for package in hyprland quickshell firefox sddm networkmanager; do
  rg -Fqx "$package" "$payload/packages" || {
    printf 'Target package list is missing: %s\n' "$package" >&2
    exit 1
  }
done
[[ -s "$payload/optional-packages.json" ]] || {
  printf 'Optional package groups are missing.\n' >&2
  exit 1
}

# The launcher and first-login welcome both open the GUI.
rg -Fqx 'Exec=/usr/local/bin/kafy-installer' "$desktop"
rg -Fq '/usr/local/bin/kafy-installer' "$welcome"

# The archinstall route remains available for manual/advanced installs, but it
# is no longer the desktop installer.
rg -Fq 'provision-target' "$fallback"

# Provisioning contract: no live-only config leaks into the target, the user's
# home is seeded without overwriting, and first boot is enabled.
rg -Fq 'rm -f "$target/etc/sddm.conf.d/kafy-live.conf" "$target/etc/sudoers.d/10-kafy-live"' "$provisioner"
rg -Fq 'cp -an "$target/etc/skel/." "$target$home/"' "$provisioner"
rg -Fq 'kafy-first-boot.service' "$provisioner"
rg -Fq '[LastUser]' "$provisioner"
rg -Fq 'Session=hyprland-uwsm.desktop' "$provisioner"
rg -Fq 'DefaultUser=%s' "$provisioner"
rg -Fq -- '-s /bin/zsh' "$backend"
rg -Fqx 'ExecStart=/usr/local/bin/kafy-first-boot' "$first_boot_unit"
rg -Fq 'wire_firefox' "$first_boot"

printf 'Kafy installation contract test passed.\n'
