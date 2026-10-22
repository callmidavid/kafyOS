# Public Release Readiness

Kafy must not be described as production-ready merely because an ISO builds or reaches a desktop. A public release requires a reproducible artifact, a safe installation path, a supported update path, and recorded hardware and recovery results.

## Current status: release engineering in progress

The source passes its static composition, installer, shell, and theme contracts. The release candidate has also been manually verified in a VM and on real hardware: it boots, completes installation, reboots into the installed system, authenticates, and has working Wi-Fi, audio, Bluetooth, suspend, display scaling, and graphics. Those results must be attached to the release record with the final ISO checksum and source commits before publication.

The following blockers must be closed before publishing Kafy as a stable release:

1. **Automated VM acceptance tests.** `test/acceptance/` is empty. It must boot the exact ISO artifact, reach the graphical live session, exercise the installer on a disposable disk, reboot the target, sign in, and capture logs/screenshots on failure.
2. **Recorded release evidence.** Attach the completed UEFI/BIOS VM and real-hardware results to the release record with the final ISO SHA-256, Kafy source commit, ISO-builder commit, hardware used, and test date.
3. **Update and migration release.** `kafy-update`, `kafy-migrate`, and `kafy-recover --check` now define the local safety boundary. The first public release must ship an empty-but-present migration directory, test an interrupted update in a disposable VM, and document the supported recovery path. A migration can never overwrite user dotfiles.
4. **Signed release integrity and channel.** The separate `kafy-iso` repository still needs a tag-triggered release workflow that emits a versioned ISO, SHA-256 manifest, detached GPG signature, and verification instructions tied to a published signing-key fingerprint. This cannot be truthfully claimed until the release key and GitHub secret are provided by the release owner.
5. **Installer scope.** The current installer intentionally erases one selected disk and creates an unencrypted ext4 installation. Until encryption, dual boot/manual partitioning, and recovery are either implemented and tested or explicitly excluded from the stable support policy, this constraint must remain prominent in release notes.
6. **Documentation parity.** The manual must describe the actual Quickshell desktop, installer, first boot, updates, support policy, and known limitations for the release being published.

## Release candidate checklist

For every candidate, record the ISO filename, SHA-256, source commit, builder commit, build timestamp, and all results below in a release issue or signed release manifest.

- Run all source and ISO composition tests.
- Verify the ISO checksum and detached signature from a second machine.
- Boot UEFI and BIOS VMs.
- Confirm SDDM, the live desktop, wallpaper, Quickshell bar, launcher, networking, audio, Bluetooth, lock screen, Firefox, and installer.
- Install to a disposable disk; reboot; log in; verify the installed desktop and that live autologin is absent.
- Verify theme/wallpaper application and first-boot finalization.
- Update the installed system using the supported update mechanism; reboot; verify the session again.
- Exercise recovery instructions after an intentionally interrupted update in a disposable VM.

## Boot experience

The ISO firmware menu exposes **Kafy OS**. It starts the Kafy live environment and reaches the Elarun-custom SDDM presentation, which autologins `liveuser` into the UWSM-managed Hyprland session. The live session opens the graphical Kafy installer after the shell has settled.

An installed Kafy system shows the same Kafy SDDM greeter with the installed account selected. It does not autologin. After password authentication it starts the UWSM-managed Hyprland session and Kafy Quickshell desktop.
