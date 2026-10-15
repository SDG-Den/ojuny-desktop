lib:
let
  inherit (lib) concatStringsSep mapAttrsToList;

  argsFor = b: if builtins.isList b.args then b.args else [ b.args ];

  keyFor = b: concatStringsSep "+" (b.modifier ++ b.keys);

  valueFor = b:
    concatStringsSep "," ([ b.dispatcher ] ++ argsFor b);

  mkBindTable = modeBinds:
    lib.mapAttrs' (name: b: lib.nameValuePair (keyFor b) (valueFor b)) modeBinds;

  toBindTables = binds: lib.mapAttrs (_mode: mkBindTable) binds;

  toCheatsheet = binds:
    let
      mkEntry = b: {
        key = keyFor b;
        desc = b.description;
        subcat = b.subcat or "General";
      };
    in
    {
      title = "Ojuny Binds";
      provider = "ojuny";
      binds = lib.mapAttrs (_mode: modeBinds: map mkEntry (builtins.attrValues modeBinds)) binds;
    };
in
{
  inherit toBindTables toCheatsheet;
}
