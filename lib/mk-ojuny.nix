{ lib, pkgs, mango, dux, settings, extraPackages ? [ ] }:
let
  mkConfig = (import ./mk-config.nix { inherit lib; }).mkConfig;
  rendered = mkConfig settings;

  duxSettings =
    if (settings.dux or null) != null then settings.dux else settings.dms or { };
  duxClipboardSettings =
    if (settings.duxClipboard or null) != null then settings.duxClipboard else settings.dmsClipboard or { };

  enabledPlugins = lib.filterAttrs (_: plugin: plugin.enable) (settings.plugins or { });

  pluginDir = name: plugin: if (plugin.dir or "") != "" then plugin.dir else name;

  pluginSource = name: plugin:
    let
      config = plugin.config or { };
    in
    if config == { } then
      plugin.src
    else
      pkgs.runCommand "ojuny-dux-plugin-${pluginDir name plugin}" { } ''
        mkdir -p "$out"
        cp -r ${plugin.src}/. "$out/"
        cp ${pkgs.writeText "config.json" (builtins.toJSON config)} "$out/config.json"
      '';

  mangoConfigFile = pkgs.writeText "ojuny.toml" rendered.mangoToml;

  duxConfigDir = pkgs.runCommand "ojuny-dux-config" { } ''
    mkdir -p "$out/dms/config.d" "$out/dms/cheatsheets" "$out/dms/plugins"
    cp ${pkgs.writeText "settings.json" rendered.duxJson} "$out/dms/config.d/00-ojuny.json"
    cp ${pkgs.writeText "binds.json" rendered.cheatsheetJson} "$out/dms/cheatsheets/binds.json"
    ${lib.optionalString (duxClipboardSettings != { }) ''
      cp ${pkgs.writeText "clsettings.json" rendered.duxClipboardJson} "$out/dms/clsettings.json"
    ''}
    ${lib.optionalString (settings.managePluginSettings or true) ''
      cp ${pkgs.writeText "plugin_settings.json" rendered.duxPluginSettingsJson} "$out/dms/plugin_settings.json"
    ''}
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: plugin: ''ln -s ${pluginSource name plugin} "$out/dms/plugins/${pluginDir name plugin}"'') enabledPlugins
    )}
  '';

  configLinks = {
    "mango/ojuny.toml" = mangoConfigFile;
    "dms/config.d/00-ojuny.json" = "${duxConfigDir}/dms/config.d/00-ojuny.json";
    "dms/cheatsheets/binds.json" = "${duxConfigDir}/dms/cheatsheets/binds.json";
  }
  // lib.optionalAttrs (duxClipboardSettings != { }) {
    "dms/clsettings.json" = "${duxConfigDir}/dms/clsettings.json";
  }
  // lib.optionalAttrs (settings.managePluginSettings or true) {
    "dms/plugin_settings.json" = "${duxConfigDir}/dms/plugin_settings.json";
  }
  // lib.mapAttrs' (
    name: plugin: lib.nameValuePair "dms/plugins/${pluginDir name plugin}" "${duxConfigDir}/dms/plugins/${pluginDir name plugin}"
  ) enabledPlugins;

  duxSessionFile =
    if (duxSettings.session or { }) == { } then
      null
    else
      pkgs.writeText "ojuny-dux-session.json" rendered.duxSessionJson;

  configLinker = import ./mk-linker.nix {
    inherit lib pkgs configLinks duxSessionFile;
  };

  duxWrapper = import ./mk-dux-wrapper.nix {
    inherit lib pkgs dux configLinker;
  };

  mangoWrapper = import ./mk-mango-wrapper.nix {
    inherit lib pkgs mango configLinker duxWrapper;
    runtimeInputs = with pkgs; [
      wl-clipboard
      wl-clip-persist
      cliphist
      wlr-utils
      ydotool
      jq
      fzf
      eza
      glib
      networkmanager
      cava
      khal
      matugen
      iproute2
      kdePackages.kdeconnect-kde
    ] ++ extraPackages;
  };
in
{
  inherit mangoWrapper duxWrapper mangoConfigFile duxConfigDir configLinks configLinker duxSessionFile;
  dmsWrapper = duxWrapper;
  dmsConfigDir = duxConfigDir;
  dmsSessionFile = duxSessionFile;
}
