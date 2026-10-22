-- Monitor setup.
--
-- Kafy runs on arbitrary hardware, so let Hyprland pick the preferred mode and
-- scale for every connected output. Users can pin a specific layout from the
-- Quickshell Monitors panel, which writes monitors-override.conf and is applied
-- by monitors_override.lua after this file.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})
