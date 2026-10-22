#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
shell_dir="$project_dir/config/etc/skel/.config/quickshell"
autostart="$project_dir/config/etc/skel/.config/hypr/autostart.conf"

# The adopted (Uthman-derived) Quickshell is Kafy's only shell.
for file in shell.qml components/Bar.qml components/Colors.qml; do
  [[ -s "$shell_dir/$file" ]] || {
    printf 'Missing Kafy shell file: %s\n' "$file" >&2
    exit 1
  }
done

rg -Fqx 'import Quickshell' "$shell_dir/shell.qml"
rg -Fq 'ShellRoot {' "$shell_dir/shell.qml"
rg -Fq 'FileView' "$shell_dir/components/Colors.qml"

# Hyprland must launch the shell with the canonical config path. The Lua config
# is primary; keep the hyprlang fallback in sync.
autostart_lua="$project_dir/config/etc/skel/.config/hypr/autostart.lua"
rg -Fqx 'exec-once = quickshell -p ~/.config/quickshell' "$autostart"
rg -Fq 'quickshell -p ~/.config/quickshell' "$autostart_lua"

# The live ISO welcome/installer runs from the same startup hook.
rg -Fq '/usr/local/bin/kafy-welcome' "$autostart_lua"

# The previous Kafy-owned shell must be gone.
[[ ! -e "$project_dir/bin/kafy-shell" ]] || {
  printf 'Duplicate kafy-shell command is still present.\n' >&2
  exit 1
}
[[ ! -e "$project_dir/shell/kafy" ]] || {
  printf 'Duplicate Kafy shell source is still present.\n' >&2
  exit 1
}

printf 'Kafy Shell contract test passed.\n'
