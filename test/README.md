# Kafy Tests

- `unit/` contains fast tests for scripts, profile composition, package manifests, and command behavior.
- `acceptance/` contains disposable-VM tests for ISO boot, the Kafy shell, installation, and first boot.

No visual or installer change is complete until it has a reproducible test or a recorded manual verification in `docs/first-iso-observations.md`.

Run `./test/unit/profile-composition.sh` to verify that package and live-only overlays assemble into the Archiso profile before starting a full ISO build.
