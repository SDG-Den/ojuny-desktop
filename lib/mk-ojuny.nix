{ lib, pkgs, mango, dms, settings, extraPackages ? [ ] }:
let
  mkConfig = (import ./mk-config.nix { inherit lib; }).mkConfig;
  rendered = mkConfig settings;

  enabledPlugins = lib.filterAttrs (_: plugin: plugin.enable) (settings.plugins or { });

  pluginDir = name: plugin: if (plugin.dir or "") != "" then plugin.dir else name;

  pluginSource = name: plugin:
    let
      config = plugin.config or { };
    in
    if config == { } then
      plugin.src
    else
      pkgs.runCommand "ojuny-dms-plugin-${pluginDir name plugin}" { } ''
        mkdir -p "$out"
        cp -r ${plugin.src}/. "$out/"
        cp ${pkgs.writeText "config.json" (builtins.toJSON config)} "$out/config.json"
      '';

  mangoConfigFile = pkgs.writeText "ojuny.toml" rendered.mangoToml;

  dmsConfigDir = pkgs.runCommand "ojuny-dms-config" { } ''
    mkdir -p "$out/DankMaterialShell/config.d" "$out/DankMaterialShell/cheatsheets" "$out/DankMaterialShell/plugins"
    cp ${pkgs.writeText "settings.json" rendered.dmsJson} "$out/DankMaterialShell/config.d/00-ojuny.json"
    cp ${pkgs.writeText "binds.json" rendered.cheatsheetJson} "$out/DankMaterialShell/cheatsheets/binds.json"
    ${lib.optionalString (settings.dmsClipboard or { } != { }) ''
      cp ${pkgs.writeText "clsettings.json" rendered.dmsClipboardJson} "$out/DankMaterialShell/clsettings.json"
    ''}
    ${lib.optionalString (settings.managePluginSettings or true) ''
      cp ${pkgs.writeText "plugin_settings.json" rendered.dmsPluginSettingsJson} "$out/DankMaterialShell/plugin_settings.json"
    ''}
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: plugin: ''ln -s ${pluginSource name plugin} "$out/DankMaterialShell/plugins/${pluginDir name plugin}"'') enabledPlugins
    )}
  '';

  configLinks = {
    "mango/ojuny.toml" = mangoConfigFile;
    "DankMaterialShell/config.d/00-ojuny.json" = "${dmsConfigDir}/DankMaterialShell/config.d/00-ojuny.json";
    "DankMaterialShell/cheatsheets/binds.json" = "${dmsConfigDir}/DankMaterialShell/cheatsheets/binds.json";
  }
  // lib.optionalAttrs (settings.dmsClipboard or { } != { }) {
    "DankMaterialShell/clsettings.json" = "${dmsConfigDir}/DankMaterialShell/clsettings.json";
  }
  // lib.optionalAttrs (settings.managePluginSettings or true) {
    "DankMaterialShell/plugin_settings.json" = "${dmsConfigDir}/DankMaterialShell/plugin_settings.json";
  }
  // lib.mapAttrs' (
    name: plugin: lib.nameValuePair "DankMaterialShell/plugins/${pluginDir name plugin}" "${dmsConfigDir}/DankMaterialShell/plugins/${pluginDir name plugin}"
  ) enabledPlugins;

  dmsSessionFile =
    if (settings.dms.session or { }) == { } then
      null
    else
      pkgs.writeText "ojuny-dms-session.json" rendered.dmsSessionJson;

  configLinker = import ./mk-linker.nix {
    inherit lib pkgs configLinks dmsSessionFile;
  };

  dmsWrapper = import ./mk-dms-wrapper.nix {
    inherit pkgs dms;
  };

  mangoWrapper = import ./mk-mango-wrapper.nix {
    inherit lib pkgs mango configLinker dmsWrapper;
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
  inherit mangoWrapper dmsWrapper mangoConfigFile dmsConfigDir configLinks configLinker dmsSessionFile;
}
