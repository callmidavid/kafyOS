# Kafy Production Plan

## Goal

Build Kafy as a coherent Arch and Hyprland desktop: fast and fluid like a modern macOS-inspired system, but easy to use without terminal knowledge.

Kafy takes its repository architecture from Omarchy and its visual-system approach from Uthman Dotfiles. It does not copy either project's branding, assets, or implementation wholesale.

## Reference decisions

- Hyprland is Kafy's compositor and window manager.
- Quickshell/QML is Kafy's shell technology: it owns the menu bar, dock, launcher, notifications, and control center.
- Matugen is evaluated after the static Kafy design system is stable; generated theme output is never hand-edited.
- Kafy source remains in this repository. ISO assembly moves to a separate `kafy-iso` repository, like Omarchy's separate ISO repository. Package publishing is deferred until Kafy has an installed-system update contract.
- Waybar and SwayNC are bootstrap dependencies only. They are removed once the Kafy shell replaces their responsibilities.

## Target repository layout

```text
kafy/
├── applications/   desktop entries, icons, application integration
├── bin/            kafy-* commands
├── config/         static per-user configuration and shell defaults
├── default/        assets, templates, fallback theme data
├── docs/           contributor reference
├── etc/            Kafy-owned system drop-ins
├── install/        system install, user provisioning, first-run logic
├── manual/         end-user documentation
├── migrations/     one-time upgrades for installed systems
├── plans/          approved implementation plans
├── shell/           Kafy Quickshell/QML implementation
├── test/           unit and disposable-VM acceptance tests
└── themes/         Kafy theme definitions and generated-file templates
```

```text
kafy-iso/
├── archiso/        boot configuration and Archiso-specific live files
├── builder/        ISO construction, offline mirror, release tooling
├── configs/        ISO build configuration
└── test/           ISO boot/install acceptance harness
```

## Phase 0 — Make the live baseline trustworthy

1. Fix every boot-visible error before adding visual features.
2. Confirm the Kafy wallpaper, Hyprland session, top bar, network, audio, Firefox, lock screen, and launcher in a fresh VM boot.
3. Store logs for failures and update `docs/first-iso-observations.md` with a screenshot and result.
4. Do not call the installer production-ready until it can install Kafy source, remove live autologin, provision a user, boot the installed system, and update safely.

Exit criterion: two clean consecutive VM boots with no Hyprland configuration errors and a visible Kafy wallpaper.

## Phase 1 — Move ISO assembly out of the Kafy source tree

1. Create a sibling `kafy-iso` repository. Completed: Archiso source has moved to `kafy-iso/archiso`.
2. Keep `kafy-iso` consuming a local sibling checkout through `KAFY_SOURCE` for development. Completed: its default is `../kafy`.
3. Configure builder CI to check out a selected Kafy source revision. Completed: configure the `KAFY_SOURCE_REPOSITORY` repository variable if the source repository name differs from the default.
4. Keep source-only UI, themes, docs, install logic, and source tests in this repository.
5. Add an ISO smoke-test command that boots a disposable VM and captures the first desktop frame.

Exit criterion: Kafy source and Kafy ISO can evolve independently, while a chosen Kafy commit always produces a reproducible ISO.

## Phase 2 — Establish Kafy's design system

1. Define Kafy color tokens, typography, spacing, corner radii, shadows, motion durations, and accessibility contrast in `themes/kafy/`.
2. Ship one static dark Kafy theme and a wallpaper fallback before dynamic wallpaper theming.
3. Split Hyprland configuration into monitors, input, bindings, environment, autostart, look-and-feel, and window rules.
4. Make a visual-verification checklist for each token change.

Exit criterion: Hyprland, lock screen, launcher, terminal, and login session draw from the same named design tokens.

## Phase 3 — Build the real Kafy shell

1. Add Quickshell and required QML dependencies to the ISO.
2. Implement a minimal runnable shell in `shell/`: menu bar, workspaces, clock, network/battery/audio indicators, and app launcher.
3. Replace Waybar only after the Kafy bar passes the Phase 0 smoke checks.
4. Add a centered dock with pinned apps, running-app indicators, hover animation, and drag-safe behavior.
5. Add notifications and a control center as Kafy-owned shell panels; remove SwayNC after Kafy owns the notification bus.

Exit criterion: a user can open apps, manage common system controls, see notifications, and switch apps without using a terminal or a third-party bar/menu tool.

## Phase 4 — Add a controlled theme pipeline

1. Decide whether wallpaper-driven palettes add enough value after the static theme is complete.
2. If adopted, add Matugen templates under `themes/` and generate outputs under `~/.local/state/kafy/theme/current/`.
3. Keep a versioned static fallback palette under `default/`.
4. Have the Quickshell shell read the generated palette live; regenerate other configuration from templates, never by editing source files.
5. Add a `kafy-theme` command for apply, reset, and diagnostics.

Exit criterion: changing wallpaper updates the Kafy shell consistently, can be reverted, and cannot leave an unbootable session.

## Phase 5 — Production installation and updates

1. Replace the experimental Archinstall wrapper with Kafy-owned installation orchestration.
2. Separate root-side system setup, user provisioning, and graphical first-run steps with idempotency markers.
3. Implement a safe update path and migrations before publishing installable Kafy packages or a public repository.
4. Add installed-system acceptance tests: install, reboot, login, update, restart, and recover.

Exit criterion: installation, updates, first run, and recovery work in a disposable VM without manual terminal fixes.

## Immediate next action

Rebuild from `kafy-iso` after the wallpaper and Hyprland-rule fix. Boot it in QEMU, then confirm the wallpaper and absence of the two rule errors before starting the design-system work.
