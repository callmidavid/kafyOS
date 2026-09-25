# Kafy Tests

- `unit/` contains fast tests for Kafy commands and source behavior.
- `acceptance/` contains disposable-VM tests for ISO boot, the Kafy shell, installation, and first boot.

No visual or installer change is complete until it has a reproducible test or a recorded manual verification in `docs/first-iso-observations.md`.

The ISO composition test belongs to the builder: run `../kafy-iso/test/unit/profile-composition.sh` before starting a full ISO build.

Run `./test/unit/install-contract.sh` to check the source-side installation boundary: Archinstall handoff, target provisioning, live-state removal, non-destructive dotfile seeding, and the first-boot service.

Run `./test/unit/theme-contract.sh` to ensure the Kafy theme remains the canonical source for Hyprland and Waybar visual values.

Run `./test/unit/shell-contract.sh` to verify the Kafy Shell source and its Hyprland workspace integration contract.
