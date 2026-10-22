# Kafy Migrations

This directory is the canonical source for one-time fixes to existing installed Kafy systems. The ISO builder copies it into the installer payload; installation places it at `/usr/lib/kafy/migrations`.

Name each migration `NNN-short-description.sh`, for example `010-rebuild-theme-cache.sh`. The installed `kafy-migrate` command runs them in lexical order as root and creates `/var/lib/kafy/migrations/NNN-short-description.complete` only after a script succeeds. A failed migration stops the update and leaves no completion marker, so it can be corrected and retried safely.

Every migration must be idempotent, change only Kafy-owned system state or explicitly documented user state, and preserve an existing user's configuration. New installations must already contain the correct defaults; migrations are not a substitute for fixing the source.
