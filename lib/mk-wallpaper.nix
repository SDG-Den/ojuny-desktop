{ lib, pkgs }:
{
  base,
  fills,
  colors,
}:
pkgs.runCommand "ojuny-stylix-wallpaper.png" {
  nativeBuildInputs = [ (pkgs.python3.withPackages (ps: [ ps.pillow ps.numpy ])) ];
  SOURCE_FILLS = lib.concatStringsSep " " (map (fill: fill.color) fills);
  TARGET_FILLS = lib.concatStringsSep " " (map (fill: colors.${fill.slot}) fills);
} ''
  python3 ${./recolor-wallpaper.py} ${base} "$out"
''
