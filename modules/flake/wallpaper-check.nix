{ ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      stylixColors = import ../../lib/stylix-colors.nix { inherit lib; };
      wallpaperPresets = import ../../lib/wallpaper-presets.nix;
      wallpaperSet = import ../../lib/mk-wallpaper-set.nix { inherit lib pkgs; } {
        presets = wallpaperPresets;
        colors = stylixColors.everforestDarkHard;
        userDirectory = null;
      };
    in
    {
      checks.wallpaper-set = pkgs.runCommand "check-ojuny-wallpaper-set" { } ''
        test -f ${wallpaperSet.directory}/builtin/everforest.png
        test -f ${wallpaperSet.directory}/builtin/city.png
        test -e ${wallpaperSet.directory}/builtin
        test -f ${wallpaperSet.selected}
        touch $out
      '';
    };
}
