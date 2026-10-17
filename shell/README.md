# Kafy Shell

This directory will contain Kafy's graphical shell: the menu bar, dock, application search, notification center, and control center.

Hyprland remains the compositor. The shell must be built as a separate, restartable process so Kafy can evolve its UI without coupling core window management to every desktop feature. Quickshell/QML is the preferred first implementation path because it can provide native Wayland surfaces, smooth animation, and a cohesive system UI.

`kafy/` is Kafy's active Quickshell configuration. It owns the top bar, application launcher, notification server and center, control center, and dock. Hyprland starts it through `kafy-shell`.

The launcher is `Super + Space`; notifications are `Super + N`; control center is `Super + C`. The shell’s IPC target is `kafy`, allowing the `kafy-shell` command to open these surfaces without starting a second shell process.
