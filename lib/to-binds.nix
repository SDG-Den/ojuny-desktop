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

  toCheatsheet = sources:
    let
      mkEntry = b:
        {
          key = keyFor b;
          desc = b.description;
          group = b.group or "Other";
        }
        // lib.optionalAttrs ((b.subcat or "") != "") { inherit (b) subcat; };

      entriesOf =
        binds: lib.concatMap (modeBinds: map mkEntry (builtins.attrValues modeBinds)) (builtins.attrValues binds);

      grouped = lib.groupBy (e: e.group) (lib.concatMap entriesOf sources);

      dropGroup = e: builtins.removeAttrs e [ "group" ];
    in
    {
      title = "Ojuny Binds";
      provider = "ojuny";
      binds = lib.mapAttrs (_: groupEntries: map dropGroup groupEntries) grouped;
    };
in
{
  inherit toBindTables toCheatsheet;
}
