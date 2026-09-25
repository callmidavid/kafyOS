# Kafy Tests

- `unit/` contains fast tests for Kafy commands and source behavior.
- `acceptance/` contains disposable-VM tests for ISO boot, the Kafy shell, installation, and first boot.

No visual or installer change is complete until it has a reproducible test or a recorded manual verification in `docs/first-iso-observations.md`.

The ISO composition test belongs to the builder: run `../kafy-iso/test/unit/profile-composition.sh` before starting a full ISO build.
