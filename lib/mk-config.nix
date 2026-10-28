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

  renderDux =
    dux:
    (dux.settings or { })
    // lib.optionalAttrs (dux.barConfigs or { } != { }) { barConfigs = renderBarConfigs dux.barConfigs; }
    // lib.optionalAttrs (dux.dockConfigs or { } != { }) { dockConfigs = renderDockConfigs dux.dockConfigs; }
    // lib.optionalAttrs (dux.controlCenterWidgets or { } != { }) {
      controlCenterWidgets = toArray dux.controlCenterWidgets;
    }
    // lib.optionalAttrs (dux.dashCards or { } != { }) { dashCards = toArray dux.dashCards; }
    // lib.optionalAttrs (dux.dashTabs or { } != { }) { dashTabs = toArray dux.dashTabs; }
    // lib.optionalAttrs (dux.dashOptions or { } != { }) { dashOptions = renderDashOptions dux.dashOptions; };

  mkConfig =
    {
      mango ? { },
      dux ? null,
      dms ? null,
      duxClipboard ? { },
      dmsClipboard ? { },
      plugins ? { },
      ...
    }:
    let
      duxSettings = if dux != null then dux else if dms != null then dms else { };
      clipboard = if duxClipboard != { } then duxClipboard else dmsClipboard;
      duxJson = builtins.toJSON (renderDux duxSettings);
      duxSessionJson = builtins.toJSON (duxSettings.session or { });
      duxClipboardJson = builtins.toJSON clipboard;
      duxPluginSettingsJson = builtins.toJSON (
        lib.mapAttrs (name: plugin: { enabled = plugin.enable; } // plugin.settings) (
          lib.filterAttrs (_: plugin: plugin.enable) plugins
        )
      );

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
      inherit
        duxJson
        duxSessionJson
        duxClipboardJson
        duxPluginSettingsJson
        ;
      dmsJson = duxJson;
      dmsSessionJson = duxSessionJson;
      dmsClipboardJson = duxClipboardJson;
      dmsPluginSettingsJson = duxPluginSettingsJson;
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
  inherit mkConfig flattenAttrs renderDux toArray;
  renderDms = renderDux;
}
