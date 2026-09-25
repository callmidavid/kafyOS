# Kafy Shell

This directory will contain Kafy's graphical shell: the menu bar, dock, application search, notification center, and control center.

Hyprland remains the compositor. The shell must be built as a separate, restartable process so Kafy can evolve its UI without coupling core window management to every desktop feature. Quickshell/QML is the preferred first implementation path because it can provide native Wayland surfaces, smooth animation, and a cohesive system UI.

`kafy/` is the first runnable Quickshell configuration. It exposes a themed Kafy bar with live Hyprland workspaces, a clock, and the active window title. Run it with `kafy-shell`; it deliberately renders below Waybar during the first validation stage so the existing bar remains a fallback.

Waybar is only the current status-bar dependency. After the Kafy bar is verified in a booted ISO, move it to the primary top position and remove Waybar from the session.
