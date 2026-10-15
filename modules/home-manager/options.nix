{ ... }:
{
  flake.modules.homeManager.ojuny-desktop-options = {
    imports = [ (import ../../lib/ojuny-options.nix) ];
  };
}
