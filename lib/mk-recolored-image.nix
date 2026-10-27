{ lib, pkgs }:
{
  name ? "ojuny-recolored-image.png",
  base,
  fills,
  colors,
}:
pkgs.runCommand name
  {
    nativeBuildInputs = [
      (pkgs.python3.withPackages (ps: [
        ps.pillow
        ps.numpy
      ]))
    ];
    SOURCE_FILLS = lib.concatStringsSep " " (map (fill: fill.color) fills);
    TARGET_FILLS = lib.concatStringsSep " " (map (fill: colors.${fill.slot}) fills);
  }
  ''
    python3 ${./recolor-wallpaper.py} ${base} "$out"
  ''
