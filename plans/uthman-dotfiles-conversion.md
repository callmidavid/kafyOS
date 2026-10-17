# Uthman Dotfiles Adoption (as built)

Kafy adopts the desktop from `https://github.com/codetesla51/uthman_dotfiles` as its default session. The upstream tree was imported into Kafy's product source, rebranded, stripped of personal and machine-specific content, and wired into the ISO composition and installer.

## What was imported

| Uthman source | Kafy destination | Notes |
| --- | --- | --- |
| `.config/` (hypr, quickshell, matugen, kitty, rofi, btop, cava, zsh theme, nvim, yazi, mpv, thunar, gtk, fastfetch, swayosd, zed) | `config/etc/skel/.config/` | Per-user defaults; becomes `/etc/skel/.config` and is seeded into each account. |
| `.local/bin/` | `config/etc/skel/.local/bin/` | Helper commands (`set-wallpaper`, `getTheme`, `shot`, `record`, `matugen-cursor`, …). |
| `.local/share/` | `config/etc/skel/.local/share/` | Desktop entries, portal services, icons. |
| `.zshrc`, `.gtkrc-2.0` | `config/etc/skel/` | Static shell/GTK defaults. |
| `theme-fallback/` | `config/etc/skel/.config/theme/current/` | Static palette seed so the session draws before the first matugen run. `background` points at the Kafy wallpaper. |
| `assets/fastfetch/` | `config/etc/skel/fastfetchImages/` | Referenced by the fastfetch config. |
| `sddm/elarun-custom/` | `default/usr/share/sddm/themes/elarun-custom/` | Login theme; installed to the live root and copied to targets. |
| `assets/fonts/Iceland-Regular.ttf` | `default/usr/share/fonts/TTF/` | Needed by SDDM, which cannot read `$HOME` fonts. |
| `cursor-theme/.local/share/icons/Bibata-Modern-Ice/` | `default/usr/share/icons/Bibata-Modern-Ice/` | Base the cursor generator recolors. |
| `firefox/user.js` | `default/usr/share/kafy/firefox/user.js` | Firefox chrome theming source. |
| `.config/systemd/user/` | `config/etc/skel/.config/systemd/user/` (failwatch, phone-reconnect) | Repointed from `%h/dotfiles` to `%h`. |

## Wiring changes

- `config/etc/skel/.config/hypr/hyprland.conf` is the upstream session file; it sources `~/.config/theme/current/colors.conf` and the vendored defaults. The previous Kafy `hyprland.conf`, `hyprpaper.conf`, and `waybar/` were removed.
- `config/etc/skel/.config/hypr/autostart.conf` starts `quickshell -p ~/.config/quickshell`, `awww-daemon`, `cliphist`, `matugen-cursor`, and the guarded Kafy live welcome.
- `config/etc/skel/.config/hypr/windowrules.conf` keeps the Kafy `kafy-welcome` float/center/size rules.
- `install/system/usr/local/lib/kafy/install/provision-target` now also copies the SDDM theme, the Iceland font, and the Bibata cursor base to the target, and writes `/etc/sddm.conf.d/10-theme.conf` with `Current=elarun-custom`.
- `install/live/etc/sddm.conf.d/kafy-live.conf` points SDDM at `elarun-custom`.
- `kafy-iso/archiso/packages.x86_64` gains the session dependencies (matugen, awww, hyprsunset, swayosd, cliphist, rofi, kitty, zsh, starship, cava, fastfetch, zathura, fonts, and related tools).
- `kafy-iso/test/unit/profile-composition.sh` asserts the adopted configuration (theme source line, quickshell, seeded palette, SDDM theme, Bibata base).

## Excluded from the import

- Compiled personal binaries (`mb`, `moviebox-tui`, `render`) and pip/venv console-script wrappers.
- Broken machine symlinks (`zed`, `zen`) and personal browser/portal entries (`zen.desktop`, `filemanager-portal` service).
- Personal screenshots (`assets/screenshots/`), agent skills (`.agents/`), and repo metadata (`install.sh`, `README.md`, `TODO.md`).
- The personal Obsidian vault output in `matugen/config.toml`.
- Personal wallpapers and the Wallhaven API key (never tracked upstream).

## Known open items

- Matugen's `[templates.sddm]` writes to `/usr/share/sddm/themes/elarun-custom/Palette.qml`, a root path. A normal user cannot overwrite it, so that template errors unless the theme is made user-writable or the output is redirected to user state.
- Firefox `user.js` and per-profile CSS wiring from `install.sh` is not reproduced; matugen's `getTheme` handles the CSS copies, but the initial `user.js` symlink is not created.
- The `watchcat` passwordless `nethogs` sudoers drop-in referenced by the shell is not part of the upstream repo and is not yet shipped.
- `shell/kafy` and `bin/kafy-shell` remain Kafy's own shell; the adopted session runs the Uthman Quickshell instead. Reconcile or retire one of them.
- Unverified in a VM. The next acceptance step is a disposable-VM boot to confirm the adopted session, SDDM theme, and installer window.
