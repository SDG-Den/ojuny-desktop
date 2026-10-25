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
    pluginDefaults = import ../../lib/mk-plugin-defaults.nix {
      inherit lib;
      registry = inputs.dms-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system};
    };
    ghosttyConfig = import ../../lib/mk-ghostty-config.nix {
      inherit lib pkgs;
      colors = if useStylixTheme then config.lib.stylix.colors else fallbackColors;
    };
    ghosttyWrapper = import ../../lib/mk-ghostty-wrapper.nix {
      inherit lib pkgs;
      configFile = ghosttyConfig;
    };
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
      extraPackages = [ ghosttyWrapper ] ++ cfg.defaultApps;
    };
  in
  {
    imports = [ self.modules.homeManager.ojuny-desktop-options ];

    config = lib.mkIf cfg.enable ({
      desktop.ojuny.dms.plugins = lib.mkMerge [
        pluginDefaults.module
        (lib.mkIf cfg.dankMenu.enable {
          dankMenu.settings = lib.mkDefault (
            cfg.dankMenu.settings
            // lib.optionalAttrs (cfg.dankMenu.menu != { }) { menuPath = "${menuFile}"; }
          );
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

      services.kdeconnect.enable = lib.mkDefault true;

      xdg.configFile = lib.mapAttrs' (rel: src: lib.nameValuePair rel { source = src; }) ojuny.configLinks;

      home.activation.ojunyDmsFirstLaunch = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD install -d -m 0755 "${config.xdg.configHome}/DankMaterialShell"
        $DRY_RUN_CMD touch "${config.xdg.configHome}/DankMaterialShell/.firstlaunch"
      '';

      systemd.user.services.ojuny-config = {
        Unit = {
          Description = "Seed the ojuny DankMaterialShell session";
        };
        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${ojuny.configLinker}/bin/ojuny-config --seed";
        };
        Install.WantedBy = [ "basic.target" ];
      };

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
