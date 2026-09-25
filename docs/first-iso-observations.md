# First ISO Observations

This is a factual record from the first Kafy ISO boot, not a release note. Update it as issues are fixed and re-tested.

## 2026-09-25 — QEMU live-session smoke test

Evidence: `/home/king-dav/Pictures/Screenshots/kafy.png` on the development machine.

### Confirmed working

- The ISO booted into the Hyprland live session.
- The Kafy wallpaper and Waybar top bar appeared.
- A wired NetworkManager connection was active.
- Firefox launched.
- The NetworkManager connection editor launched.

### Found and fixed in source

- Hyprland displayed errors for three deprecated `windowrulev2` entries used to float and center the Kafy welcome window. The rules were migrated, but the first replacement still omitted the required `on` values for the `float` and `center` effects. The source now uses the valid effect arguments; this requires a rebuilt ISO and a new VM boot to verify.
- The Kafy wallpaper was not visible in the updated VM screenshot. The live session now starts Hyprpaper through `kafy-wallpaper`, which validates the image, records Hyprpaper output in `~/.cache/kafy/hyprpaper.log`, retries the IPC connection, and explicitly preloads and applies the wallpaper. This requires a rebuilt ISO and a new VM boot to verify.

### Not yet verified

- The welcome flow and installer completion path.
- Audio, Bluetooth, suspend/resume, display scaling, and GPU-specific behavior.
- Installed-system boot, user provisioning, and removal of live-session autologin.
- BIOS boot and physical-hardware boot.
