#!/usr/bin/env bash
set -euo pipefail

# Kafy's desktop theming is generated at runtime by Matugen from the wallpaper.
# The static themes/kafy tree is legacy and no longer drives the session, so this
# contract checks the live theme source of truth instead.
project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
skel_config="$project_dir/config/etc/skel/.config"
theme_current="$skel_config/theme/current"
hyprland_config="$skel_config/hypr/hyprland.conf"
matugen_config="$skel_config/matugen/config.toml"

for file in colors.conf hyprland.conf hyprlock.conf btop.theme cava_theme; do
  [[ -s "$theme_current/$file" ]] || {
    printf 'Missing current theme file: %s\n' "$file" >&2
    exit 1
  }
done

# Hyprland consumes the generated palette and the theme's own window rules.
rg -Fqx 'source = ~/.config/theme/current/colors.conf' "$hyprland_config"
rg -Fqx 'source = ~/.config/theme/current/hyprland.conf' "$hyprland_config"

# Matugen must generate both the shell palette and the shared theme palette.
rg -Fq 'output_path = "~/.config/quickshell/colors.css"' "$matugen_config"
rg -Fq 'output_path = "~/.config/theme/current/colors.conf"' "$matugen_config"

# The login screen palette is generated too; its input template must exist.
rg -Fq 'input_path = "~/.config/matugen/templates/sddm-palette.qml"' "$matugen_config"
[[ -s "$skel_config/matugen/templates/sddm-palette.qml" ]] || {
  printf 'Missing SDDM palette template.\n' >&2
  exit 1
}

printf 'Kafy theme contract test passed.\n'
