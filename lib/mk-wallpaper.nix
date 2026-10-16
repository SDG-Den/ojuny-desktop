{ lib, pkgs }:
let
  fills = [
    {
      color = "2e383c";
      slot = "base00";
    }
    {
      color = "4f5b58";
      slot = "base02";
    }
    {
      color = "4b5654";
      slot = "base02";
    }
    {
      color = "dbbc7f";
      slot = "base0A";
    }
    {
      color = "7fbbb3";
      slot = "base08";
    }
    {
      color = "e67e80";
      slot = "base0E";
    }
    {
      color = "689e6a";
      slot = "base0B";
    }
  ];
in
{
  base ? ./wallpapers/everforest.png,
  colors,
}:
pkgs.runCommand "ojuny-stylix-wallpaper.png" {
  nativeBuildInputs = [ (pkgs.python3.withPackages (ps: [ ps.pillow ps.numpy ])) ];
  SOURCE_FILLS = lib.concatStringsSep " " (map (fill: fill.color) fills);
  TARGET_FILLS = lib.concatStringsSep " " (map (fill: colors.${fill.slot}) fills);
} ''
  python3 ${./recolor-wallpaper.py} ${base} "$out"
''
