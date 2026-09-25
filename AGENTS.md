# Kafy Contributor Guide

## Repository layout

- `manual/`: end-user documentation. Never describe unfinished work as available product behavior.
- `docs/`: contributor reference for architecture, files, builds, testing, and decisions.
- `config/`: static system and `/etc/skel` defaults.
- `default/`: Kafy-owned assets and templates.
- `bin/`: Kafy commands, diagnostics, and runtime helpers.
- `install/`: live-session setup, installation, and installed-system provisioning.
- `shell/`: Kafy-specific graphical shell.
- `test/`: automated and VM acceptance tests.

Archiso metadata, package manifests, boot configuration, and ISO CI live in the separate `kafy-iso` repository. Its `archiso/prepare-profile.sh` consumes this repository's `config/`, `default/`, `install/live/`, and `bin/kafy-doctor` at build time.

## Rules

- Keep a Kafy feature in one canonical source; do not duplicate settings between source trees and the Archiso profile.
- Prefix user-facing commands with `kafy-`.
- Keep static per-user defaults in `config/etc/skel`. Put runtime work that needs `$HOME`, a graphical session, or hardware detection in `bin/` or `install/`.
- Keep live-only behavior under `install/live`; it must not be copied into an installed system.
- Do not overwrite an existing user's configuration without an explicit, documented reset or migration.
- Verify visual changes in a running ISO or disposable VM and record relevant results.
- Use full lines in Markdown; do not hard-wrap prose.
