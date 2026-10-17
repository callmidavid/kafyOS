#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
shell_dir="$project_dir/shell/kafy"

for file in shell.qml KafyBar.qml KafyLauncher.qml KafyControlCenter.qml KafyNotificationCenter.qml KafyDock.qml; do
  [[ -s "$shell_dir/$file" ]] || {
    printf 'Missing Kafy Shell file: %s\n' "$file" >&2
    exit 1
  }
done

rg -Fqx 'import Quickshell' "$shell_dir/shell.qml"
rg -Fqx 'import Quickshell.Hyprland' "$shell_dir/KafyBar.qml"
rg -Fq 'model: Hyprland.workspaces' "$shell_dir/KafyBar.qml"
rg -Fq 'onClicked: modelData.activate()' "$shell_dir/KafyBar.qml"
rg -Fq 'NotificationServer {' "$shell_dir/shell.qml"
rg -Fq 'DesktopEntries.applications.values' "$shell_dir/KafyLauncher.qml"
rg -Fq 'trackedNotifications' "$shell_dir/KafyNotificationCenter.qml"
rg -Fq 'nm-connection-editor' "$shell_dir/KafyControlCenter.qml"
rg -Fq 'wpctl' "$shell_dir/KafyControlCenter.qml"
rg -Fq 'Firefox' "$shell_dir/KafyDock.qml"
bash -n "$project_dir/bin/kafy-shell"

printf 'Kafy Shell contract test passed.\n'
