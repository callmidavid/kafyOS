# Kafy Installation and Provisioning

This directory owns installation orchestration and first-run provisioning.

The installer must install Arch, copy the Kafy configuration and assets from this source tree, create the requested user, and run explicit system and user finalization. It must remove all live-image autologin state before the installed system boots.

`live/` contains only the commands and configuration needed while booted from the ISO. `system/` is a target payload: it is carried inside the ISO and copied to the installed system only after Archinstall has completed successfully.

`kafy-installer` deliberately hands disk partitioning and base installation to Archinstall's supported interactive flow. It then invokes `kafy-install-target`, which applies Kafy defaults to `/mnt/archinstall`, removes live-only autologin and sudo rules, seeds the chosen user's home directory without overwriting files, and installs the idempotent per-user first-boot finalizer.

This is an installation foundation, not a production installer claim. The next acceptance test must prove an install, reboot, login, and Kafy desktop session in a disposable VM.
