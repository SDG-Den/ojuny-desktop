{ self, inputs, ... }:
{
  flake.modules.nixos.ojuny-desktop = { config, lib, pkgs, options, ... }:
  let
    cfg = config.desktop.ojuny;
    toMenuJson = (import ../../lib/dank-menu.nix { inherit lib; }).toMenuJson;
    menuFile = pkgs.writeText "ojuny-dankmenu.json" (toMenuJson cfg.dankMenu.menu);
    mangoDefaults = import ../../lib/defaults/mango.nix;
    dmsDefaults = import ../../lib/defaults/dms.nix;
    perKeyDefaults = lib.mapAttrs (_: lib.mkDefault);
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

    session = (pkgs.runCommand "ojuny-desktop-session" { } ''
      mkdir -p "$out/share/wayland-sessions"
      cat > "$out/share/wayland-sessions/ojuny.desktop" <<EOF
      [Desktop Entry]
      Name=Ojuny Desktop
      Comment=Ojuny Desktop (mangoWM + DankMaterialShell)
      Exec=${ojuny.mangoWrapper}/bin/ojuny-mango
      Type=Application
      DesktopNames=mango;wlroots
      EOF
    '').overrideAttrs (old: {
      passthru = (old.passthru or { }) // {
        providedSessions = [ "ojuny" ];
      };
    });
  in
  {
    imports = [ self.modules.nixos.ojuny-desktop-options ];

    config = lib.mkIf cfg.enable ({
      desktop.ojuny.dms.plugins = lib.mkMerge [
        (lib.mapAttrs (_: plugin: { src = lib.mkDefault plugin; }) (
          inputs.dms-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system}
        ))
        (lib.mkIf cfg.dankMenu.enable {
          dankMenu.enable = true;
          dankMenu.settings = cfg.dankMenu.settings // lib.optionalAttrs (cfg.dankMenu.menu != { }) { menuPath = "${menuFile}"; };
        })
      ];
      desktop.ojuny.defaultApps = lib.mkAfter (with pkgs; [ ghostty firefox nautilus ]);

      desktop.ojuny.mango.execOnce = lib.mkAfter [
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE"
        "systemctl --user reset-failed"
        "systemctl --user start xdg-desktop-autostart.target"
      ];

      desktop.ojuny.mango.global = perKeyDefaults
        (mangoDefaults.global
          // lib.optionalAttrs (cfg.stylix.enable && stylixAvailable)
            (mangoColors config.lib.stylix.colors));

      desktop.ojuny.dms.settings = perKeyDefaults
        (dmsDefaults.settings
          // lib.optionalAttrs (cfg.stylix.enable && stylixAvailable) {
            currentThemeName = "custom";
            customThemeFile = "${dankThemeFile}";
            fontFamily = config.stylix.fonts.sansSerif.name;
            monoFontFamily = config.stylix.fonts.monospace.name;
            popupTransparency = config.stylix.opacity.popups;
            dockTransparency = config.stylix.opacity.desktop;
          });

      desktop.ojuny.dms.session = perKeyDefaults
        (lib.optionalAttrs
          (cfg.stylix.enable && stylixAvailable && config.stylix.image != null)
          {
            wallpaperPath = config.stylix.image;
            wallpaperPathLight = config.stylix.image;
            wallpaperPathDark = config.stylix.image;
          });

      environment.systemPackages = [ ojuny.mangoWrapper ] ++ cfg.defaultApps;

      services.displayManager.sessionPackages = [ session ];

      xdg.portal = {
        enable = lib.mkDefault true;
        wlr.enable = lib.mkDefault true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };

      security.polkit.enable = lib.mkDefault true;
      programs.xwayland.enable = lib.mkDefault true;
      services.graphical-desktop.enable = lib.mkDefault true;

      assertions = [{
        assertion = !cfg.stylix.enable || stylixAvailable;
        message = "desktop.ojuny.stylix.enable requires the stylix module to be imported (e.g. inputs.stylix.nixosModules.stylix).";
      }];
    } // lib.optionalAttrs (options ? stylix) {
      stylix.image = lib.mkIf
        (cfg.stylix.enable && options.stylix.base16Scheme.highestPrio < 1500)
        (lib.mkDefault stylixWallpaper);
    });
  };
}
