{ ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      menuLib = import ../../lib/dank-menu.nix { inherit lib; };
      menu = {
        learn = {
          icon = "school";
          label = "Learn";
        };
        "learn.keybinds" = {
          icon = "keyboard";
          label = "Keybinds";
          action = "dms ipc call keybinds open binds";
        };
      };
      extraEntries = {
        "learn.menu-fixture" = {
          icon = "science";
          label = "Menu fixture";
          action = "true";
        };
      };
      merged = menuLib.merge menu extraEntries;
      menuJson = menuLib.toMenuJson merged;
      menuUnchanged =
        merged.learn == menu.learn
        && merged."learn.keybinds" == menu."learn.keybinds"
        && lib.removeAttrs merged [ "learn.menu-fixture" ] == menu;
    in
    {
      checks.menu-extra-entries =
        assert menuUnchanged;
        assert lib.hasInfix "\"learn.menu-fixture\"" menuJson;
        assert lib.hasInfix "\"Menu fixture\"" menuJson;
        assert lib.hasInfix "\"learn.keybinds\"" menuJson;
        pkgs.runCommand "check-ojuny-menu-extra-entries" { } ''
          touch $out
        '';
    };
}
