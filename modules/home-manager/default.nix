{ self, inputs, ... }:
{
  flake.modules.homeManager.ojuny-desktop = { config, lib, pkgs, options, ... }:
  let
    cfg = config.desktop.ojuny;
    toMenuJson = (import ../../lib/dank-menu.nix { inherit lib; }).toMenuJson;
    menuFile = pkgs.writeText "ojuny-dankmenu.json" (toMenuJson cfg.dankMenu.menu);
    mangoDefaults = import ../../lib/defaults/mango.nix;
    dmsDefaults = import ../../lib/defaults/dms.nix;
    stylixColors = import ../../lib/stylix-colors.nix { inherit lib; };
    mangoColors = stylixColors.mangoColors;
    dankThemeFile = pkgs.writeText "ojuny-dms-stylix-theme.json" (
      builtins.toJSON (stylixColors.dankTheme config.lib.stylix.colors)
    );
    mkWallpaper = import ../../lib/mk-wallpaper.nix { inherit lib pkgs; };
    stylixWallpaper = mkWallpaper { colors = config.lib.stylix.colors; };
    stylixAvailable = options ? stylix;
    ojuny = import ../../lib/mk-ojuny.nix {
      inherit lib pkgs;
      mango = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;
      dms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        inherit (cfg) mango;
        dms = {
          settings = cfg.dms.settings;
          session = cfg.dms.session;
          inherit (cfg.dms)
            barConfigs
            dockConfigs
            controlCenterWidgets
            dashCards
            dashTabs
            dashOptions
            ;
        };
        dmsClipboard = cfg.dms.clipboardSettings;
        plugins = cfg.dms.plugins;
        managePluginSettings = cfg.dms.managePluginSettings;
      };
      extraPackages = cfg.defaultApps;
    };
  in
  {
    imports = [ self.modules.homeManager.ojuny-desktop-options ];

    config = lib.mkIf cfg.enable ({
      desktop.ojuny.dms.plugins = lib.mkMerge [
        (lib.mapAttrs (_: plugin: { src = lib.mkDefault plugin; }) (
          inputs.dms-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system}
        ))
        {
          nixMonitor = {
            dir = lib.mkDefault "NixMonitor";
            config = lib.mkDefault {
              generationsCommand = [ "sh" "-c" "ls -1 /nix/var/nix/profiles | grep -e 'system-' | wc -l" ];
              storeSizeCommand = [ "sh" "-c" "du -sh /nix/store 2>/dev/null | cut -f1" ];
              gcCommand = [ "sh" "-c" "nix-collect-garbage -d 2>&1" ];
              localRevisionCommand = [ "sh" "-c" "nixos-version --hash 2>/dev/null | cut -c 1-7 || echo 'N/A'" ];
              remoteRevisionCommand = [ "sh" "-c" "git ls-remote https://github.com/NixOS/nixpkgs.git nixos-unstable 2>/dev/null | cut -c 1-7 || echo 'N/A'" ];
              nixpkgsChannel = "nixos-unstable";
              updateInterval = 300;
              rebuildCommand = [ "sh" "-c" "sudo nixos-rebuild switch --flake .#$(hostname)" ];
            };
          };
        }
        (lib.mkIf cfg.dankMenu.enable {
          dankMenu = {
            enable = true;
            settings = cfg.dankMenu.settings // lib.optionalAttrs (cfg.dankMenu.menu != { }) {
              menuPath = "${menuFile}";
            };
          };
        })
      ];
      desktop.ojuny.defaultApps = lib.mkDefault (with pkgs; [ ghostty firefox nautilus ]);

      desktop.ojuny.mango.execOnce = lib.mkAfter [
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE"
        "systemctl --user reset-failed"
        "systemctl --user start mango-session.target"
      ];

      systemd.user.targets.mango-session = {
        Unit = {
          Description = "mango compositor session";
          Documentation = [ "man:systemd.special(7)" ];
          BindsTo = [ "graphical-session.target" ];
          Wants = [
            "graphical-session-pre.target"
            "xdg-desktop-autostart.target"
          ];
          After = [ "graphical-session-pre.target" ];
          Before = [ "xdg-desktop-autostart.target" ];
        };
      };

      desktop.ojuny.mango.global = lib.mkIf (cfg.stylix.enable && stylixAvailable) (
        lib.mkDefault (mangoDefaults.global // mangoColors config.lib.stylix.colors)
      );

      desktop.ojuny.dms.settings = lib.mkIf (cfg.stylix.enable && stylixAvailable) (
        lib.mkDefault (dmsDefaults.settings // {
          currentThemeName = "custom";
          customThemeFile = "${dankThemeFile}";
          fontFamily = config.stylix.fonts.sansSerif.name;
          monoFontFamily = config.stylix.fonts.monospace.name;
          popupTransparency = config.stylix.opacity.popups;
          dockTransparency = config.stylix.opacity.desktop;
        })
      );

      desktop.ojuny.dms.session = lib.mkIf
        (cfg.stylix.enable && stylixAvailable && config.stylix.image != null)
        (lib.mkDefault {
          wallpaperPath = config.stylix.image;
          wallpaperPathLight = config.stylix.image;
          wallpaperPathDark = config.stylix.image;
        });

      home.packages = [ ojuny.mangoWrapper ] ++ cfg.defaultApps;

      home.file = lib.mapAttrs' (rel: src: lib.nameValuePair ".config/${rel}" { source = src; }) ojuny.dmsConfigLinks;

      home.activation.ojunyDmsFirstLaunch = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD install -d -m 0755 "$HOME/.config/DankMaterialShell"
        $DRY_RUN_CMD touch "$HOME/.config/DankMaterialShell/.firstlaunch"
      '';

      assertions = [{
        assertion = !cfg.stylix.enable || stylixAvailable;
        message = "desktop.ojuny.stylix.enable requires the stylix module to be imported (e.g. inputs.stylix.homeManagerModules.stylix).";
      }];
    } // lib.optionalAttrs (options ? stylix) {
      stylix.image = lib.mkIf
        (cfg.stylix.enable && options.stylix.base16Scheme.highestPrio < 1500)
        (lib.mkDefault stylixWallpaper);
    });
  };
}
