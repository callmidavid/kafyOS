#!/bin/bash
set -euo pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
profile_dir="$project_dir/distro/kafy"
staging_dir=$(mktemp -d)
trap 'rm -rf "$staging_dir"' EXIT

"$profile_dir/prepare-profile.sh" "$staging_dir" >/dev/null

required_files=(
  "airootfs/etc/skel/.config/hypr/hyprland.conf"
  "airootfs/usr/share/wallpapers/kafy/contents/images/1920x1080.png"
  "airootfs/usr/local/bin/kafy-doctor"
  "airootfs/usr/local/bin/kafy-installer"
  "airootfs/etc/sddm.conf.d/kafy-live.conf"
  "airootfs/etc/mkinitcpio.conf.d/archiso.conf"
)

for required_file in "${required_files[@]}"; do
  [[ -f "$staging_dir/$required_file" ]] || {
    printf 'Missing composed file: %s\n' "$required_file" >&2
    exit 1
  }
done

printf 'Kafy profile composition test passed.\n'
