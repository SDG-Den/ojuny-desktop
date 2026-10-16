# ojuny-desktop

Pre-configured [mangoWM](https://github.com/mangowm/mango) + [DankMaterialShell](https://github.com/SDG-Den/DankMaterialShell) desktop layer for NixOS and Home Manager, generated entirely from Nix options.

## Features

- Single source of truth: all mango/DMS settings exposed under `desktop.ojuny.*`
- Store-derived configs: TOML/JSON generated in the Nix store; mango launched with `-c`, and the generated DMS config tree symlinked to `~/.config/DankMaterialShell` (all users on NixOS)
- Keybinds/cheatsheet generated from the same bind definitions
- DMS plugin support (from `dms-plugin-registry`) with structured plugin settings
- Optional dankMenu configuration via structured `desktop.ojuny.dankMenu.menu`
- Optional stylix integration mapping colors into mango's global theme
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
        desktop.ojuny.defaultApps = with pkgs; [ ghostty firefox nautilus ];
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
- `dms.settings`, `dms.clipboardSettings`, `dms.managePluginSettings`, `dms.plugins.<name> = { enable; src; settings; }`
- `dms.barConfigs`, `dms.dockConfigs`, `dms.controlCenterWidgets`, `dms.dashCards`, `dms.dashTabs`, `dms.dashOptions` — id-keyed convenience options rendered to DMS arrays (order via `_order`)
- `dankMenu.enable`, `dankMenu.menu.<dotted-id>`, `dankMenu.settings`
- `stylix.enable` — requires stylix module imported
- `defaultApps` — list of packages added to session PATH

## Notes
- Plugin sources from the DMS plugin registry are injected with `mkDefault`; override `desktop.ojuny.dms.plugins.<name>.src` to pin.
- When `desktop.ojuny.dankMenu.menu` is non-empty and `dankMenu.enable` is true, a generated menu JSON is set via `menuPath` in plugin settings.
- The DMS config tree is symlinked from the store to `~/.config/DankMaterialShell`; everything is store-derived and `~/.config` is otherwise left alone.
