#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
output_dir="${1:-$profile_dir/out}"

if [[ $EUID -ne 0 ]]; then
  echo "Run this builder as root: sudo ./build.sh [output-directory]" >&2
  exit 1
fi

if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "archiso is required. On an Arch-based build host: pacman -S --needed archiso" >&2
  exit 1
fi

rm -rf "$output_dir/work"
mkdir -p "$output_dir"
mkarchiso -v -w "$output_dir/work" -o "$output_dir" "$profile_dir"

iso_file=$(find "$output_dir" -maxdepth 1 -name 'kafy-os-*.iso' -print -quit)
if [[ -z $iso_file ]]; then
  echo "Build completed but no Kafy ISO was found." >&2
  exit 1
fi

sha256sum "$iso_file" > "$iso_file.sha256"
echo "Created: $iso_file"
echo "Checksum: $iso_file.sha256"
