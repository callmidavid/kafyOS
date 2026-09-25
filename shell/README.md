# Kafy Shell

This directory will contain Kafy's graphical shell: the menu bar, dock, application search, notification center, and control center.

Hyprland remains the compositor. The shell must be built as a separate, restartable process so Kafy can evolve its UI without coupling core window management to every desktop feature. Quickshell/QML is the preferred first implementation path because it can provide native Wayland surfaces, smooth animation, and a cohesive system UI.

Waybar is only the current status-bar dependency. New Kafy visual work belongs here and must be real, runnable shell code rather than copied desktop configuration.
