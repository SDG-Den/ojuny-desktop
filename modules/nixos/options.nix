{ lib, ... }:
{
  flake.modules.nixos.ojuny-desktop-options = {
    imports = [
      (import ../../lib/ojuny-options.nix)
      (lib.mkRenamedOptionModule [ "desktop" "ojuny" "dms" ] [ "desktop" "ojuny" "dux" ])
    ];
  };
}
