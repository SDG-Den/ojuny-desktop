{ lib }:
let
  toTOML = (import ./to-toml.nix lib).toTOML;
  bindsLib = import ./to-binds.nix lib;

  flattenAttrs =
    attrs:
    let
      go = prefix: values:
        builtins.foldl' (
          acc: key:
          let
            v = values.${key};
            newKey = if prefix == "" then key else "${prefix}_${key}";
          in
          acc // (if builtins.isAttrs v then go newKey v else { "${newKey}" = v; })
        ) { } (builtins.attrNames values);
    in
    go "" attrs;

  sortEntries =
    attrs:
    lib.sort (
      a: b:
      let
        ao = a.value._order or 1000;
        bo = b.value._order or 1000;
      in
      if ao == bo then a.name < b.name else ao < bo
    ) (lib.mapAttrsToList (name: value: { inherit name value; }) attrs);

  toArray = attrs: map (e: (lib.removeAttrs e.value [ "_order" ]) // { id = e.name; }) (sortEntries attrs);

  renderBarConfigs =
    attrs:
    toArray (
      lib.mapAttrs (
        _: e:
        (lib.removeAttrs e [ "leftWidgets" "rightWidgets" ])
        // lib.optionalAttrs (e ? leftWidgets) { leftWidgets = toArray e.leftWidgets; }
        // lib.optionalAttrs (e ? rightWidgets) { rightWidgets = toArray e.rightWidgets; }
      ) attrs
    );

  renderDockConfigs =
    attrs:
    toArray (
      lib.mapAttrs (
        _: e:
        (lib.removeAttrs e [ "widgets" ])
        // lib.optionalAttrs (e ? widgets) { widgets = toArray e.widgets; }
      ) attrs
    );

  renderDashOptions =
    opts:
    opts
    // lib.optionalAttrs ((opts.weather or { }) ? widgets) {
      weather = opts.weather // { widgets = toArray opts.weather.widgets; };
    };

  renderDms =
    dms:
    (dms.settings or { })
    // lib.optionalAttrs (dms.barConfigs or { } != { }) { barConfigs = renderBarConfigs dms.barConfigs; }
    // lib.optionalAttrs (dms.dockConfigs or { } != { }) { dockConfigs = renderDockConfigs dms.dockConfigs; }
    // lib.optionalAttrs (dms.controlCenterWidgets or { } != { }) {
      controlCenterWidgets = toArray dms.controlCenterWidgets;
    }
    // lib.optionalAttrs (dms.dashCards or { } != { }) { dashCards = toArray dms.dashCards; }
    // lib.optionalAttrs (dms.dashTabs or { } != { }) { dashTabs = toArray dms.dashTabs; }
    // lib.optionalAttrs (dms.dashOptions or { } != { }) { dashOptions = renderDashOptions dms.dashOptions; };

  mkConfig = { mango ? { }, dms ? { }, dmsClipboard ? { }, plugins ? { }, ... }:
    let
      global = flattenAttrs (mango.global or { })
        // lib.optionalAttrs (mango.execOnce or [ ] != [ ]) { exec_once = mango.execOnce; }
        // lib.optionalAttrs (mango.exec or [ ] != [ ]) { exec = mango.exec; }
        // lib.optionalAttrs (mango.source or [ ] != [ ]) { source = mango.source; };

      bindTables = bindsLib.toBindTables (mango.binds or { });
      rules = lib.filterAttrs (_: v: v != [ ]) (mango.rules or { });

      sections =
        [ { name = "global"; value = global; } ]
        ++ lib.optional (mango.env or { } != { }) { name = "env"; value = mango.env; }
        ++ lib.optional (mango.var or { } != { }) { name = "var"; value = mango.var; }
        ++ lib.optional (bindTables != { }) { name = "bind"; value = bindTables; }
        ++ lib.optional (mango.mousebind or { } != { }) {
          name = "mousebind";
          value = bindsLib.toBindTables mango.mousebind;
        }
        ++ lib.optional (mango.axisbind or { } != { }) {
          name = "axisbind";
          value = bindsLib.toBindTables mango.axisbind;
        }
        ++ lib.optional (mango.gesturebind or { } != { }) {
          name = "gesturebind";
          value = bindsLib.toBindTables mango.gesturebind;
        }
        ++ lib.optional (rules != { }) { name = "rule"; value = rules; };
    in
    {
      mangoToml = toTOML sections;
      dmsJson = builtins.toJSON (renderDms dms);
      dmsSessionJson = builtins.toJSON (dms.session or { });
      dmsClipboardJson = builtins.toJSON dmsClipboard;
      dmsPluginSettingsJson = builtins.toJSON (
        lib.mapAttrs (name: plugin: { enabled = plugin.enable; } // plugin.settings) (
          lib.filterAttrs (_: plugin: plugin.enable) plugins
        )
      );
      cheatsheetJson = builtins.toJSON (
        bindsLib.toCheatsheet (
          map (key: mango.${key} or { }) [
            "binds"
            "mousebind"
            "axisbind"
          ]
        )
      );
    };
in
{
  inherit mkConfig flattenAttrs renderDms toArray;
}
