{ lib, pkgs }:
{
  base,
  fills,
  colors,
}:
import ./mk-recolored-image.nix { inherit lib pkgs; } {
  name = "ojuny-stylix-wallpaper.png";
  inherit base fills colors;
}
