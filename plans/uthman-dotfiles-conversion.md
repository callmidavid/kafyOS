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
| `.config/systemd/user/` | `config/etc/skel/.config/systemd/user/` (failwatch, phone-reconnect, watchcat) | Repointed from `%h/dotfiles` to `%h`; `watchcat` is enabled via `graphical-session.target.wants`. |

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

## Fixes applied after the initial import

- **SDDM palette.** Matugen's `[templates.sddm]` rewrites `Palette.qml` in place (new inode), so the theme directory must be writable by the desktop account. `provision-target` now `chown`s `/usr/share/sddm/themes/elarun-custom` to the user, and `customize_airootfs.sh` does the same for `liveuser` on the live ISO.
- **Firefox.** `getTheme` symlinks `/usr/share/kafy/firefox/user.js` into each detected profile and refreshes the chrome CSS; `kafy-first-boot` repeats the wiring for profiles that already exist at first login.
- **WatchCat.** Added the `nethogs` package, a `watchcat.service` user unit enabled through `graphical-session.target.wants`, and a scoped `/etc/sudoers.d/kafy-watchcat` rule (`%wheel … NOPASSWD: /usr/bin/nethogs`). Opt out with `systemctl --user disable --now watchcat.service`.
- **Duplicate shell retired.** `shell/kafy`, `bin/kafy-shell`, and the `/etc/xdg/quickshell/kafy` composition are gone. The Uthman-derived Quickshell in `/etc/skel/.config/quickshell` is Kafy's only shell; `test/unit/shell-contract.sh` asserts that and fails if the old shell returns.
- **Matugen output dirs.** Seeded `~/.config/zathura/` and `~/.config/cavasik/` so every configured template has a writable destination.

## Remaining open items

- `themes/kafy` and `bin/kafy-theme` are now vestigial: nothing in the adopted session reads the static theme. Decide whether to retire them too.
- Matugen's `reload_apps.waybar` targets Waybar, which is not installed; harmless but unused.
- Unverified in a VM. The next acceptance step is a disposable-VM boot to confirm the session, SDDM theme, cursor, wallpaper, and installer window, then an install/reboot cycle and a wallpaper change to confirm Matugen recolors the desktop and the login screen.
