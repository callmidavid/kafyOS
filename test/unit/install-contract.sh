#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
installer="$project_dir/install/live/usr/local/bin/kafy-installer"
target_provisioner="$project_dir/install/system/usr/local/lib/kafy/install/provision-target"
first_boot="$project_dir/install/system/usr/local/bin/kafy-first-boot"
first_boot_unit="$project_dir/install/system/etc/systemd/user/kafy-first-boot.service"

for file in "$installer" "$target_provisioner" "$first_boot"; do
  bash -n "$file"
done

rg -Fqx 'archinstall' "$installer"
rg -Fq 'kafy-install-target --target "$target" --user "$user"' "$installer"
rg -Fq 'rm -f "$target/etc/sddm.conf.d/kafy-live.conf" "$target/etc/sudoers.d/10-kafy-live"' "$target_provisioner"
rg -Fq 'cp -an "$target/etc/skel/." "$target$home/"' "$target_provisioner"
rg -Fq 'kafy-first-boot.service' "$target_provisioner"
rg -Fqx 'ExecStart=/usr/local/bin/kafy-first-boot' "$first_boot_unit"

printf 'Kafy installation contract test passed.\n'
