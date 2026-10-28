# ojuny-desktop

Pre-configured [mangoWM](https://github.com/mangowm/mango) + [Dux Shell](https://github.com/duxlabs-dev/dux-shell) desktop layer for NixOS and Home Manager, generated entirely from Nix options.

## Features

- Single source of truth: all mango/Dux Shell settings exposed under `desktop.ojuny.*`
- Store-derived configs: TOML/JSON generated in the Nix store; mango launched with `-c ~/.config/mango/ojuny.toml`, and each generated Dux Shell config file symlinked into `~/.config/dms` (which stays writable; all users on NixOS)
- Shared session bootstrap: the first-launch marker and Dux Shell session state are seeded by the same linker for `nix run`, NixOS, and Home Manager
- Keybinds/cheatsheet generated from the same bind definitions
- Dux Shell plugin support (from `dux-plugin-registry`) with structured plugin settings, including a default set used by the bar, control center, and menu
- Optional file manager selection (`dux-files` by default, `nautilus`, or a custom package/command), with MIME and FileChooser portal wiring
- Optional dankMenu configuration via structured `desktop.ojuny.dankMenu.menu`
- Optional stylix integration mapping colors into mango's global theme and Ghostty
- `ojuny-ghostty` wrapper that layers the ojuny Ghostty defaults under the user's existing Ghostty config
- Home Manager installs a `wayland-sessions/ojuny.desktop` entry in the user profile for display managers configured to scan it
- `nix run` provides a self-contained nested desktop for testing

## Usage

### nix run (try it)
```bash
nix run github:your-org/ojuny-desktop
```

### NixOS (flakes)
```nix
{
  inputs = {
    ojuny-desktop.url = "github:your-org/ojuny-desktop";
    nixpkgs.follows = "nixpkgs";
    home-manager.follows = "nixpkgs";
    stylix.follows = "nixpkgs"; # optional
  };
  outputs = { ojuny-desktop, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        ojuny-desktop.nixosModules.default
        # optionally stylix.nixosModules.stylix
        {
          desktop.ojuny.enable = true;
          # desktop.ojuny.stylix.enable = true;
        }
      ];
    };
  };
}
```

### Home Manager (flakes)
```nix
{
  homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
    modules = [
      ojuny-desktop.homeManagerModules.default
      # optionally stylix.homeManagerModules.stylix
      {
        desktop.ojuny.enable = true;
        desktop.ojuny.defaultApps = with pkgs; [ ghostty firefox ];
        desktop.ojuny.fileManager.package = "dux-files";
        desktop.ojuny.dankMenu.enable = true;
        desktop.ojuny.dankMenu.menu."learn.keybinds" = {
          icon = "keyboard";
          label = "Keybinds";
          action = "dms ipc call keybinds open binds";
        };
      }
    ];
  };
}
```

## Options overview
Key options under `desktop.ojuny.*`:
- `enable` — enable the desktop layer
- `mango.*` — global/env/var/exec, rules, binds (mode->name), mousebind/axisbind/gesturebind
- `dux.settings`, `dux.clipboardSettings`, `dux.managePluginSettings`, `dux.plugins.<name> = { enable; src; settings; }`
- `dux.barConfigs`, `dux.dockConfigs`, `dux.controlCenterWidgets`, `dux.dashCards`, `dux.dashTabs`, `dux.dashOptions` — id-keyed convenience options rendered to Dux Shell arrays (order via `_order`)
- `fileManager.enable` — install and wire a file manager (default true)
- `fileManager.package` — `dux-files` (default), `nautilus`, or `custom`
- `fileManager.customPackage`, `fileManager.customCommand` — package and command used with `custom`
- `fileManager.portal` — register the Dux Files FileChooser portal backend (default true)
- `dankMenu.enable`, `dankMenu.menu.<dotted-id>`, `dankMenu.settings`
- `stylix.enable` — requires stylix module imported
- `wallpaper.preset` — bundled wallpaper preset, recolored with the active palette
- `wallpaper.image` — custom wallpaper path that overrides the preset and is used as-is
- `wallpaper.userDirectory` — directory of user wallpapers copied into the generated wallpaper directory
- `wallpaper.cycleIncludeBuiltins` — include bundled presets when Dux Shell cycles wallpapers
- `defaultApps` — list of packages added to session PATH

## Notes
- Plugin sources from the Dux Shell plugin registry are injected with `mkDefault`; override `desktop.ojuny.dux.plugins.<name>.src` to pin. `dankMenu`, `dankKDEConnect`, `nixMonitor`, `localServices`, `scratchpadHelper`, and `developerUtilities` are enabled with `mkDefault` because the default bar, control center, and binds use them. Set `desktop.ojuny.dux.plugins.<name>.enable = false` to disable one.
- When `desktop.ojuny.dankMenu.menu` is non-empty and `dankMenu.enable` is true, a generated menu JSON is set via `menuPath` in plugin settings. The dankMenu plugin itself stays enabled with its bundled menu otherwise.
- The generated Dux Shell config files are symlinked from the store into `~/.config/dms`, which stays a writable directory; everything is store-derived. The Dux Shell session file is copied into `~/.local/state/dms` with writable permissions, so runtime session changes such as wallpaper cycling work; a changed generated session replaces it on the next activation.
- On NixOS the `ojuny-config` user oneshot repoints every generated link during activation (`restartTriggers`), so a switch updates `~/.config` without a relogin. Restart Dux Shell afterwards to reload both Dux Shell and mango.
- `nix run` uses temporary `XDG_CONFIG_HOME`, `XDG_STATE_HOME`, `XDG_CACHE_HOME`, and `XDG_DATA_HOME` directories, runs the same linker, and seeds the first-launch marker and session state there. It does not touch the user's Dux Shell configuration.
- `desktop.ojuny.dms.*` was renamed to `desktop.ojuny.dux.*`; the old path is kept as a renamed-option shim and still evaluates with a warning.
- Terminal binds and the startup terminal use `ojuny-ghostty`. That wrapper loads the generated ojuny Ghostty config first and then the user's existing `ghostty/config` and `config.ghostty`, so user settings win. The raw `ghostty` binary is not replaced in NixOS or Home Manager. Under `nix run`, the generated config is also placed in the temporary `XDG_CONFIG_HOME`.
- The Home Manager session entry is installed at `$profile/share/wayland-sessions/ojuny.desktop`. GDM and LightDM do not scan the user profile by default. Symlink it into `/usr/share/wayland-sessions`, or point a display manager with a configurable session directory at the profile path.
