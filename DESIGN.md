# ojuny-desktop design

## Overview
ojuny-desktop provides a wrapped desktop package and NixOS/Home Manager modules bundling pre-configured mangoWM + DankMaterialShell (DMS). It generates mango TOML and DMS JSON from Nix options and launches both via a wrapper that points them at store paths (no ~/.config writes).

Based on dendrite's mango/DMS configuration, using upstream `mangowm/mango` and `SDG-Den/DankMaterialShell`. Excludes g13, noodle variants, and personal-specific configs.

## Namespace
All options live under `desktop.ojuny.*` and are shared across NixOS and Home Manager.

## Configuration generation
- Mango: TOML generated via custom `lib/to-toml.nix` from structured options (flattened `[global]` keys; binds, mousebinds, axisbinds, gesturebinds as tables; rules as arrays). Written to a store path and passed via `mango -c`.
- DMS: `settings.json`, `clsettings.json` (clipboard), `binds.json` (cheatsheet), `plugin_settings.json` written into a config directory; `XDG_CONFIG_HOME` is set to that directory for the DMS process. The wrapper exposes this directory via `ojuny-dms-config`.
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
- `lib/mk-ojuny.nix`: builds `mangoConfigFile`, `dmsConfigDir`, `mangoWrapper`, `dmsWrapper` from settings; symlinks enabled plugins
- `lib/mk-mango-wrapper.nix`, `lib/mk-dms-wrapper.nix`: wrapper derivations (mango gets `-c`; DMS gets `XDG_CONFIG_HOME` pointing to config dir)
- `lib/defaults/*.nix`: default mango/DMS/clipboard values
- `lib/dank-menu.nix`: serializes structured dankMenu tree to JSON (filters null/empty)
- `lib/stylix-colors.nix`: maps stylix base16 colors to mango global color tokens

## Plugin registry
DMS plugin registry (`inputs.dms-plugin-registry`) is mapped into `desktop.ojuny.dms.plugins.<name>.src = mkDefault ...` for both HM and NixOS, allowing overrides.

## Nested runner (packages/desktop-runner)
`packages.default` provides `ojuny-desktop` script that runs the wrapped session under `dbus-run-session` for a self-contained try-it experience with defaults.

## What to exclude/port
Exclude: g13, noodle variants, personal configurations. Use upstream mango and upstream DMS. Port generically; no `~/.config` writes.
