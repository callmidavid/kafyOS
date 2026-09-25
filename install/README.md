# Kafy Installation and Provisioning

This directory owns installation orchestration and first-run provisioning.

The installer must install Arch, copy the Kafy configuration and assets from this source tree, create the requested user, and run explicit system and user finalization. It must remove all live-image autologin state before the installed system boots.

The existing `kafy-installer` command is experimental and remains under `install/live/` until this contract is implemented and tested.
