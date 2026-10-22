# ISO Validation Observations

This is a factual validation record, not a release note. Every entry must identify its evidence and must not turn an unrecorded claim into a release guarantee.

## 2026-10-22 — release-candidate validation

Evidence: maintainer-reported VM installation/reboot test and real-hardware test; the latest QEMU screenshot shows the Kafy wallpaper, native Quickshell bar, and graphical installer.

### Confirmed by the maintainer

- The installer completed in a VM, and the target rebooted into the installed Kafy session.
- Login, Wi-Fi, audio, Bluetooth, suspend, display scaling, and graphics were tested.
- The same functional areas were tested on real hardware.

### Still required for a public release

- Store the final ISO checksum, Kafy commit, ISO-builder commit, BIOS/UEFI result, and hardware matrix in the release record.
- Run an automated disposable-VM acceptance path against the exact signed ISO artifact.
- Exercise `kafy-update` and a deliberately interrupted update plus the documented recovery path in a disposable VM.

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
- The Kafy wallpaper was not visible in the updated VM screenshot. The live session now applies the wallpaper through `awww` (`awww-daemon` plus `awww img` in `autostart.conf`, with `set-wallpaper` for changes). The earlier Hyprpaper-based `kafy-wallpaper` helper was retired along with the legacy static theme. This requires a rebuilt ISO and a new VM boot to verify.

### Not yet verified

- The welcome flow and installer completion path.
- Audio, Bluetooth, suspend/resume, display scaling, and GPU-specific behavior.
- Installed-system boot, user provisioning, and removal of live-session autologin.
- BIOS boot and physical-hardware boot.
