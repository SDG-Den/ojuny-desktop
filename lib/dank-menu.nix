{ lib }:
{
  merge = menu: extraEntries: lib.recursiveUpdate menu extraEntries;
  toMenuJson = menu:
    builtins.toJSON (
      lib.mapAttrs (_: row: lib.filterAttrs (_: value: value != null && value != [ ]) row) menu
    );
}
