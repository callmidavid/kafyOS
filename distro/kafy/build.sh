#!/usr/bin/env bash
set -euo pipefail

profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
output_dir="${1:-$profile_dir/out}"

if ! command -v mkarchiso >/dev/null 2>&1; then
  if ! command -v docker >/dev/null 2>&1; then
    echo "archiso is required, or install Docker to build from Ubuntu/Debian." >&2
    exit 1
  fi

  mkdir -p "$output_dir"
  echo "mkarchiso is unavailable; building in an Arch Linux container."
  docker run --rm --privileged \
    -v "$profile_dir:/profile:ro" \
    -v "$output_dir:/output" \
    archlinux:latest \
    bash -lc 'pacman -Syu --noconfirm archiso && mkarchiso -v -w /output/work -o /output /profile'
else
  if [[ $EUID -ne 0 ]]; then
    echo "Run this builder as root on an Arch host: sudo ./build.sh [output-directory]" >&2
    exit 1
  fi

  rm -rf "$output_dir/work"
  mkdir -p "$output_dir"
  mkarchiso -v -w "$output_dir/work" -o "$output_dir" "$profile_dir"
fi

iso_file=$(find "$output_dir" -maxdepth 1 -name 'kafy-os-*.iso' -print -quit)
if [[ -z $iso_file ]]; then
  echo "Build completed but no Kafy ISO was found." >&2
  exit 1
fi

sha256sum "$iso_file" > "$iso_file.sha256"
echo "Created: $iso_file"
echo "Checksum: $iso_file.sha256"
