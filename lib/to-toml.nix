lib:
let
  escapeString = s:
    "\"" + lib.replaceStrings [ "\\" "\"" "\n" "\t" ] [ "\\\\" "\\\"" "\\n" "\\t" ] s + "\"";

  bareKey = k: builtins.match "[A-Za-z0-9_-]+" k != null;

  keyFor = k: if bareKey k then k else escapeString k;

  pathFor = path: lib.concatStringsSep "." (map keyFor path);

  isScalar = v:
    builtins.isBool v || builtins.isInt v || builtins.isFloat v || lib.isString v || lib.isPath v;

  isValueList = v: builtins.isList v && lib.all (x: !builtins.isAttrs x) v;

  isArrayOfTables = v: builtins.isList v && lib.all builtins.isAttrs v;

  scalar = v:
    if builtins.isBool v then (if v then "true" else "false")
    else if builtins.isInt v then toString v
    else if builtins.isFloat v then toString v
    else if lib.isString v then escapeString v
    else if lib.isPath v then escapeString (toString v)
    else throw "toTOML: unsupported value of type ${builtins.typeOf v}";

  value = v:
    if builtins.isList v then "[" + lib.concatMapStringsSep ", " value v + "]"
    else scalar v;

  keyValues = attrs:
    lib.concatStrings (lib.mapAttrsToList
      (k: v: "${keyFor k} = ${value v}\n")
      attrs);

  renderTable = path: attrs:
    let
      scalars = lib.filterAttrs (_: v: isScalar v || isValueList v) attrs;
      childTables = lib.filterAttrs (_: v: builtins.isAttrs v) attrs;
      childArrays = lib.filterAttrs (_: v: isArrayOfTables v) attrs;

      selfBlock =
        lib.optionalString (scalars != { }) ("[" + pathFor path + "]\n" + keyValues scalars + "\n");

      nested = lib.concatStrings (lib.mapAttrsToList
        (k: v: renderTable (path ++ [ k ]) v)
        childTables);

      arrays = lib.concatStrings (lib.mapAttrsToList
        (k: v: lib.concatMapStrings
          (el: "[[" + pathFor (path ++ [ k ]) + "]]\n" + keyValues el + "\n")
          v)
        childArrays);
    in
    selfBlock + nested + arrays;

  toTOML = sections:
    lib.concatStrings (map
      (s:
        if builtins.isAttrs s.value then renderTable [ s.name ] s.value
        else if isArrayOfTables s.value then
          lib.concatMapStrings
            (el: "[[" + keyFor s.name + "]]\n" + keyValues el + "\n")
            s.value
        else "${keyFor s.name} = ${value s.value}\n")
      sections);
in
{
  inherit toTOML;
}
