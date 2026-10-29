{ lib, registry }:
let
  defaults = import ./defaults/plugins.nix { inherit lib registry; };

  mkDefaultDeep =
    value:
    if lib.isDerivation value || lib.isPath value || lib.isList value then
      lib.mkDefault value
    else if lib.isAttrs value then
      if value == { } then
        lib.mkDefault value
      else
        lib.mapAttrs (_: mkDefaultDeep) value
    else
      lib.mkDefault value;
in
{
  inherit defaults;
  module = lib.mapAttrs (_: mkDefaultDeep) defaults;
}
