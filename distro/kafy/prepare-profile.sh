#!/bin/bash
set -euo pipefail

profile_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
project_dir=$(cd "$profile_dir/../.." && pwd)
staging_dir=${1:?"Usage: prepare-profile.sh STAGING_DIRECTORY"}

rm -rf "$staging_dir"
mkdir -p "$staging_dir"

# The profile contains only Archiso-specific files. Kafy product sources are
# composed into it at build time so the ISO never becomes their source of truth.
tar -C "$profile_dir" \
  --exclude='./out' \
  --exclude='./cache' \
  --exclude='./work' \
  --exclude='./.gitignore' \
  -cf - . | tar -C "$staging_dir" -xf -

for source_tree in "$project_dir/config" "$project_dir/default" "$project_dir/install/live"; do
  tar -C "$source_tree" -cf - . | tar -C "$staging_dir/airootfs" -xf -
done

install -Dm755 "$project_dir/bin/kafy-doctor" "$staging_dir/airootfs/usr/local/bin/kafy-doctor"

printf 'Prepared Archiso profile at %s\n' "$staging_dir"
