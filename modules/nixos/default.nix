{ self, inputs, ... }:
{
  flake.modules.nixos.ojuny-desktop = { config, lib, pkgs, ... }:
  let
    cfg = config.desktop.ojuny;
    toMenuJson = (import ../../lib/dank-menu.nix { inherit lib; }).toMenuJson;
    menuFile = pkgs.writeText "ojuny-dankmenu.json" (toMenuJson cfg.dankMenu.menu);
    mangoDefaults = import ../../lib/defaults/mango.nix;
    mangoColors = (import ../../lib/stylix-colors.nix { inherit lib; }).mangoColors;
    stylixAvailable = (config.lib or { }) ? stylix;
    ojuny = import ../../lib/mk-ojuny.nix {
      inherit lib pkgs;
      mango = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;
      dms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        inherit (cfg) mango;
        dms = {
          settings = cfg.dms.settings;
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

    config = lib.mkIf cfg.enable {
      desktop.ojuny.dms.plugins = lib.mkMerge [
        (lib.mapAttrs (_: plugin: { src = lib.mkDefault plugin; }) (
          inputs.dms-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system}
        ))
        (lib.mkIf cfg.dankMenu.enable {
          dankMenu.enable = true;
          dankMenu.settings = cfg.dankMenu.settings // lib.optionalAttrs (cfg.dankMenu.menu != { }) { menuPath = "${menuFile}"; };
        })
      ];
      desktop.ojuny.defaultApps = lib.mkDefault (with pkgs; [ ghostty firefox nautilus ]);

      desktop.ojuny.mango.global = lib.mkIf (cfg.stylix.enable && stylixAvailable) (
        lib.mkDefault (mangoDefaults.global // mangoColors config.lib.stylix.colors)
      );

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
    };
  };
}
