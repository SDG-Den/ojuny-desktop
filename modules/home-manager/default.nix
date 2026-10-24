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
    fallbackColors = stylixColors.everforestDarkHard;
    fallbackWallpaper = "${../../lib/wallpapers/everforest.png}";
    fallbackThemeFile = pkgs.writeText "ojuny-dms-everforest-theme.json" (
      builtins.toJSON stylixColors.fallbackTheme
    );
    stylixThemeFile = pkgs.writeText "ojuny-dms-stylix-theme.json" (
      builtins.toJSON (stylixColors.dankTheme config.lib.stylix.colors)
    );
    mkWallpaper = import ../../lib/mk-wallpaper.nix { inherit lib pkgs; };
    stylixWallpaper = mkWallpaper { colors = config.lib.stylix.colors; };
    stylixAvailable = options ? stylix;
    useStylixTheme = cfg.stylix.enable && stylixAvailable;
    useFallbackTheme = !stylixAvailable;
    ojuny = import ../../lib/mk-ojuny.nix {
      inherit lib pkgs;
      mango = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;
      dms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        inherit (cfg) mango;
        dms = {
          settings = cfg.dms.settings;
          session = cfg.dms.session;
          barConfigs = lib.recursiveUpdate dmsDefaults.barConfigs cfg.dms.barConfigs;
          inherit (cfg.dms)
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
            config.generationsCommand = lib.mkDefault [ "sh" "-c" "ls -1 /nix/var/nix/profiles | grep -e 'system-' | wc -l" ];
            config.storeSizeCommand = lib.mkDefault [ "sh" "-c" "du -sh /nix/store 2>/dev/null | cut -f1" ];
            config.gcCommand = lib.mkDefault [ "sh" "-c" "nix-collect-garbage -d 2>&1" ];
            config.localRevisionCommand = lib.mkDefault [ "sh" "-c" "nixos-version --hash 2>/dev/null | cut -c 1-7 || echo 'N/A'" ];
            config.remoteRevisionCommand = lib.mkDefault [ "sh" "-c" "git ls-remote https://github.com/NixOS/nixpkgs.git nixos-unstable 2>/dev/null | cut -c 1-7 || echo 'N/A'" ];
            config.nixpkgsChannel = lib.mkDefault "nixos-unstable";
            config.updateInterval = lib.mkDefault 300;
            config.rebuildCommand = lib.mkDefault [ "sh" "-c" "sudo nixos-rebuild switch --flake .#$(hostname)" ];
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

      desktop.ojuny.mango.global = lib.mkIf (useStylixTheme || useFallbackTheme) (
        lib.mkDefault (
          mangoDefaults.global
          // (
            if useStylixTheme then
              mangoColors config.lib.stylix.colors
            else
              mangoColors fallbackColors
          )
        )
      );

      desktop.ojuny.dms.settings = lib.mkIf (useStylixTheme || useFallbackTheme) (
        lib.mkDefault (
          dmsDefaults.settings
          // (
            if useStylixTheme then {
              currentThemeName = "custom";
              customThemeFile = "${stylixThemeFile}";
              fontFamily = config.stylix.fonts.sansSerif.name;
              monoFontFamily = config.stylix.fonts.monospace.name;
              popupTransparency = config.stylix.opacity.popups;
              dockTransparency = config.stylix.opacity.desktop;
            } else {
              currentThemeName = "custom";
              customThemeFile = "${fallbackThemeFile}";
            }
          )
        )
      );

      desktop.ojuny.dms.session = lib.mkIf
        ((useStylixTheme && config.stylix.image != null) || useFallbackTheme)
        (lib.mkDefault (
          if useStylixTheme && config.stylix.image != null then {
            wallpaperPath = config.stylix.image;
            wallpaperPathLight = config.stylix.image;
            wallpaperPathDark = config.stylix.image;
          } else {
            wallpaperPath = fallbackWallpaper;
            wallpaperPathLight = fallbackWallpaper;
            wallpaperPathDark = fallbackWallpaper;
          }
        ));

      home.packages = [ ojuny.mangoWrapper ] ++ cfg.defaultApps;

      home.file = lib.mapAttrs' (rel: src: lib.nameValuePair ".config/${rel}" { source = src; }) ojuny.configLinks;

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
