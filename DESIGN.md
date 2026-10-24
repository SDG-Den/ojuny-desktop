# ojuny-desktop design

## Overview
ojuny-desktop provides a wrapped desktop package and NixOS/Home Manager modules bundling pre-configured mangoWM + DankMaterialShell (DMS). It generates mango TOML and DMS JSON from Nix options. Mango is launched with `-c` against `~/.config/mango/ojuny.toml`, a stable symlink into the store; the generated DMS config tree is symlinked from the store into `~/.config/DankMaterialShell` so DMS reads it from the normal config location and keeps writing its own output to `~/.config`.

Based on dendrite's mango/DMS configuration, using upstream `mangowm/mango` and `SDG-Den/DankMaterialShell`. Excludes g13, noodle variants, and personal-specific configs.

## Namespace
All options live under `desktop.ojuny.*` and are shared across NixOS and Home Manager.

## Configuration generation
- Mango: TOML generated via custom `lib/to-toml.nix` from structured options (flattened `[global]` keys; binds, mousebinds, axisbinds, gesturebinds as tables; rules as arrays). Written to a store path and linked as `~/.config/mango/ojuny.toml`, which the wrapper passes via `mango -c`. The link sits beside any user-owned `config.toml`/`config.conf`; mango's watcher matches events by exact path, so only `ojuny.toml` changes trigger a reload.
- DMS: the settings are rendered into a `config.d/00-ojuny.json` fragment, alongside `clsettings.json` (clipboard), `cheatsheets/binds.json`, `plugin_settings.json` and plugin sources, in a store `DankMaterialShell` config tree. Each generated file is symlinked individually into `~/.config/DankMaterialShell`, which stays a real, writable directory so DMS can create and update its own files there (`ojuny-config` user oneshot with `restartTriggers` on NixOS for all users, `home.file` on Home Manager); no `XDG_CONFIG_HOME` override. `lib/mk-ojuny.nix` returns the link map as `configLinks` and the tree as `dmsConfigDir` (`ojuny-dms-config`).
- Keybinds: single source of truth in `desktop.ojuny.mango.binds/*` and related bind groups; cheatsheet JSON is generated from them via `lib/to-binds.nix`.

## Flake structure (dendritic)
- flake-parts based. Modules imported via `importTree ./modules`.
- `packages.<system>.default` = nested desktop runner (`packages/desktop-runner/default.nix`).
- Exports: `nixosModules.default = self.modules.nixos.ojuny-desktop`, `homeManagerModules.default`/`homeModules.default = self.modules.homeManager.ojuny-desktop`.

## Option schema
- `desktop.ojuny.enable` (bool)
- `desktop.ojuny.mango.global` (TOML/attrs), `env`, `var`, `execOnce`, `exec`, `source`, `rules` (TOML), `binds`, `mousebind`, `axisbind`, `gesturebind` (bind groups)
- `desktop.ojuny.mango.binds.<mode>.<name> = { modifier = [string]; keys = [string]; dispatcher = string; args = list|string; description = string; subcat = string; }`
- `desktop.ojuny.dms.settings` (TOML, settings.json), `clipboardSettings` (clsettings.json), `managePluginSettings` (bool)
- `desktop.ojuny.dms.{barConfigs,dockConfigs,controlCenterWidgets,dashCards,dashTabs}` (attrsOf keyed by id) and `dashOptions` (TOML) — convenience options rendered to DMS arrays by `lib/mk-config.nix`; per-entry `_order` controls array position
- `desktop.ojuny.dms.plugins.<name> = { enable = bool; src = path/package; settings = TOML; }`
- `desktop.ojuny.dankMenu.enable` (bool), `menu.<id>` (structured menu rows), `settings` (extra plugin settings)
- `desktop.ojuny.stylix.enable` (bool) — maps stylix colors to mango global colors when stylix is imported
- `desktop.ojuny.defaultApps = [ package ... ]`

## Modules
- `modules/nixos/options.nix`: shared options definition (`lib/ojuny-options.nix` consumed)
- `modules/nixos/default.nix`: NixOS entrypoint; sets up session package (`ojuny` session), portals (wlr/gtk), polkit, xwayland, registers plugin sources from registry with mkDefault, applies dankMenu/stylix wiring, installs default apps
- `modules/home-manager/options.nix`: re-exports shared options
- `modules/home-manager/default.nix`: HM entrypoint; similar plugin/stylix/dankMenu wiring; installs `ojuny-mango` wrapper and default apps

## Core libraries
- `lib/ojuny-options.nix`: shared `desktop.ojuny.*` option definitions
- `lib/mk-config.nix`: renders `mangoToml`, `dmsJson`, `dmsClipboardJson`, `cheatsheetJson`, `dmsPluginSettingsJson`
- `lib/to-toml.nix`: custom ordered TOML renderer for mango schema
- `lib/to-binds.nix`: converts bind groups to DMS cheatsheet JSON and to TOML bind tables
- `lib/mk-ojuny.nix`: builds `mangoConfigFile`, `dmsConfigDir`, `configLinks`, `configLinker`, `mangoWrapper`, `dmsWrapper` from settings; symlinks enabled plugins
- `lib/mk-linker.nix`: writes `ojuny-config`, which links `configLinks` into the user config directory, seeds `session.json`, touches the DMS first-launch marker, and clears the legacy `~/.config/DankMaterialShell` symlink
- `lib/mk-mango-wrapper.nix`, `lib/mk-dms-wrapper.nix`: wrapper derivations (mango runs `ojuny-config --links-only` then gets the stable `-c` path; the DMS wrapper supplies the DMS runtime PATH and points the state dir at the store)
- `lib/mk-ghostty-config.nix`: renders the ojuny Ghostty settings and base16 palette into a store config
- `lib/mk-ghostty-wrapper.nix`: builds `ojuny-ghostty`, which loads the generated config before the user's Ghostty config so user values win
- `lib/defaults/*.nix`: default mango/DMS/clipboard/plugin values
- `lib/mk-plugin-defaults.nix`: produces plain plugin defaults for the runner and `mkDefault`-wrapped defaults for the modules
- `lib/dank-menu.nix`: serializes structured dankMenu tree to JSON (filters null/empty)
- `lib/stylix-colors.nix`: maps stylix base16 colors to mango global color tokens

## Plugin registry
DMS plugin registry (`inputs.dms-plugin-registry`) is mapped into `desktop.ojuny.dms.plugins.<name>.src = mkDefault ...` for both HM and NixOS, allowing overrides. `lib/defaults/plugins.nix` enables `dankMenu`, `dankKDEConnect`, `nixMonitor`, `localServices`, `scratchpadHelper`, and `developerUtilities` with `mkDefault` because the default UI references them. Their runtime dependencies (`iproute2`, `kdePackages.kdeconnect-kde`) are part of the session PATH, with `kdeconnect` enabled as a user service on NixOS and Home Manager.

## Nested runner (packages/desktop-runner)
`packages.default` provides `ojuny-desktop` script that runs the wrapped session under `dbus-run-session` for a self-contained try-it experience with defaults. It uses temporary `XDG_CONFIG_HOME` and `XDG_STATE_HOME` directories, invokes the same `ojuny-config` linker as the modules, enables the shared plugin set, and places the generated Ghostty config in the temporary config home.

## Ghostty
Terminal binds and the startup terminal use `ojuny-ghostty`. The wrapper loads the generated config first, then the user's existing `$XDG_CONFIG_HOME/ghostty/config` and `config.ghostty`, with default file loading disabled. Because later files win, existing user settings are preserved. The raw `ghostty` binary is not replaced.

## What to exclude/port
Exclude: g13, noodle variants, personal configurations. Use upstream mango and upstream DMS. Port generically; no `~/.config` writes.
