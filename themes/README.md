# Kafy Themes

Each theme is a real, static fallback that can draw the Kafy session with no generated palette. Its directory owns its visual values; desktop configuration only consumes those files.

`kafy/` is the current production theme. It supplies Hyprland visual tokens, the Waybar stylesheet, and the Kafy Shell palette. `bin/kafy-theme verify` checks that the installed theme is complete.

Wallpaper-derived colors are not part of this contract yet. They may be added later as generated runtime output, never by editing these source files.
