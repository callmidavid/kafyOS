#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(cd "$profile_dir/../.." && pwd)"
output_dir="${1:-$profile_dir/out}"
work_dir="${KAFY_WORK_DIR:-$profile_dir/work}"
staging_dir="$work_dir/profile"

if ! command -v mkarchiso >/dev/null 2>&1; then
  if ! command -v docker >/dev/null 2>&1; then
    echo "archiso is required, or install Docker to build from Ubuntu/Debian." >&2
    exit 1
  fi

  mkdir -p "$output_dir" "$profile_dir/cache/pkg" "$profile_dir/cache/db"
  echo "mkarchiso is unavailable; building in an Arch Linux container."
  docker run --rm --privileged \
    -v "$project_dir:/project:ro" \
    -v "$output_dir:/output" \
    -v "$profile_dir/cache/pkg:/var/cache/pacman/pkg" \
    -v "$profile_dir/cache/db:/var/lib/pacman/sync" \
    archlinux:latest \
    bash -lc 'pacman -Syu --noconfirm archiso && cd /project/distro/kafy && KAFY_WORK_DIR=/tmp/kafy-archiso-work ./build.sh /output'
else
  if [[ $EUID -ne 0 ]]; then
    echo "Run this builder as root on an Arch host: sudo ./build.sh [output-directory]" >&2
    exit 1
  fi

  rm -rf "$work_dir"
  mkdir -p "$output_dir"
  "$profile_dir/prepare-profile.sh" "$staging_dir"
  mkarchiso -v -w "$work_dir/archiso" -o "$output_dir" "$staging_dir"
fi

iso_file=$(find "$output_dir" -maxdepth 1 -name 'kafy-os-*.iso' -print -quit)
if [[ -z $iso_file ]]; then
  echo "Build completed but no Kafy ISO was found." >&2
  exit 1
fi

sha256sum "$iso_file" > "$iso_file.sha256"
echo "Created: $iso_file"
echo "Checksum: $iso_file.sha256"
