-- Extra autostart processes (from autostart.conf).
--
-- Wrapped in the hyprland.start event: a top-level hl.exec_cmd() runs at config
-- parse time — including during `Hyprland --verify-config` and on every
-- `hyprctl reload` — which would re-spawn all of these. `exec-once` means
-- "once at startup", which is exactly the hyprland.start handler.
hl.on("hyprland.start", function()
  hl.exec_cmd("wl-paste --watch cliphist store")
  hl.exec_cmd("awww-daemon")
  -- Wait for the daemon socket before painting, otherwise the first image
  -- request races startup and the session comes up with a black background.
  hl.exec_cmd([[sh -c 'for i in $(seq 1 50); do awww query >/dev/null 2>&1 && break; sleep 0.2; done; bg=$(readlink -f "$HOME/.config/theme/current/background" 2>/dev/null); [ -n "$bg" ] && [ -f "$bg" ] && awww img "$bg" --transition-type none']])
  hl.exec_cmd("~/.local/bin/matugen-cursor")
  hl.exec_cmd("quickshell -p ~/.config/quickshell")
  hl.exec_cmd("pkill -x swayosd-server")
  -- Wipe runaway capture overlays (slurp/hyprpicker) if a key ever sticks at login
  hl.exec_cmd("~/.config/hypr/scripts/picker-guard.sh")
  -- Materialize the wallpaper palette on first login. The target seeds the
  -- wallpaper and fallback theme but not the generated colors.css/colors.lua.
  hl.exec_cmd([[sh -c '[ -f "$HOME/.config/quickshell/colors.css" ] || ~/.local/bin/getTheme "$(readlink -f "$HOME/.config/theme/current/background")" >/dev/null 2>&1']])
  -- Kafy live-session welcome/installer — present only on the ISO, so guard it.
  hl.exec_cmd([[sh -c '[ -x /usr/local/bin/kafy-welcome ] && /usr/local/bin/kafy-welcome']])
end)
