#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
theme_dir="$project_dir/themes/kafy"
hyprland_config="$project_dir/config/etc/skel/.config/hypr/hyprland.conf"
waybar_style="$project_dir/config/etc/skel/.config/waybar/style.css"

for file in metadata.json hyprland.conf waybar.css shell/KafyTheme.qml; do
  [[ -s "$theme_dir/$file" ]] || {
    printf 'Missing Kafy theme file: %s\n' "$file" >&2
    exit 1
  }
done

rg -Fqx 'source = /usr/share/kafy/themes/kafy/hyprland.conf' "$hyprland_config"
rg -Fqx '@import url("/usr/share/kafy/themes/kafy/waybar.css");' "$waybar_style"
bash -n "$project_dir/bin/kafy-theme"

printf 'Kafy theme contract test passed.\n'
