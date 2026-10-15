{ ... }:
{
  flake.modules.nixos.ojuny-desktop-options = {
    imports = [ (import ../../lib/ojuny-options.nix) ];
  };
}
