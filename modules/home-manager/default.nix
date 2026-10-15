{ self, inputs, ... }:
{
  flake.modules.homeManager.ojuny-desktop = { config, lib, pkgs, ... }:
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
  in
  {
    imports = [ self.modules.homeManager.ojuny-desktop-options ];

    config = lib.mkIf cfg.enable {
      desktop.ojuny.dms.plugins = lib.mkMerge [
        (lib.mapAttrs (_: plugin: { src = lib.mkDefault plugin; }) (
          inputs.dms-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system}
        ))
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

      desktop.ojuny.mango.global = lib.mkIf (cfg.stylix.enable && stylixAvailable) (
        lib.mkDefault (mangoDefaults.global // mangoColors config.lib.stylix.colors)
      );

      home.packages = [ ojuny.mangoWrapper ] ++ cfg.defaultApps;

      assertions = [{
        assertion = !cfg.stylix.enable || stylixAvailable;
        message = "desktop.ojuny.stylix.enable requires the stylix module to be imported (e.g. inputs.stylix.homeManagerModules.stylix).";
      }];
    };
  };
}
