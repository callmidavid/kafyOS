# Kafy Installed-System Release Payload

Everything in this directory is copied by the installer into an installed Kafy system. It contains only Kafy-owned commands and release metadata; Arch packages continue to be owned and upgraded by `pacman`.

`kafy-update` performs an Arch full upgrade and then runs the versioned, idempotent migrations in `/usr/lib/kafy/migrations`. It never copies `/etc/skel` over an existing home directory.

The ISO builder must compose the root `migrations/` directory here as `/usr/lib/kafy/migrations`. A stable release also requires the ISO repository to publish a signed ISO and its matching release manifest before `kafy-update` may be advertised as a public update channel.
