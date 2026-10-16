{ lib, pkgs, mango, dms, settings, extraPackages ? [ ] }:
let
  mkConfig = (import ./mk-config.nix { inherit lib; }).mkConfig;
  rendered = mkConfig settings;

  enabledPlugins = lib.filterAttrs (_: plugin: plugin.enable) (settings.plugins or { });

  mangoConfigFile = pkgs.writeText "ojuny-mango.toml" rendered.mangoToml;

  dmsConfigDir = pkgs.runCommand "ojuny-dms-config" { } ''
    mkdir -p "$out/DankMaterialShell/cheatsheets" "$out/DankMaterialShell/plugins"
    cp ${pkgs.writeText "settings.json" rendered.dmsJson} "$out/DankMaterialShell/settings.json"
    cp ${pkgs.writeText "binds.json" rendered.cheatsheetJson} "$out/DankMaterialShell/cheatsheets/binds.json"
    ${lib.optionalString (settings.dmsClipboard or { } != { }) ''
      cp ${pkgs.writeText "clsettings.json" rendered.dmsClipboardJson} "$out/DankMaterialShell/clsettings.json"
    ''}
    ${lib.optionalString (settings.managePluginSettings or true) ''
      cp ${pkgs.writeText "plugin_settings.json" rendered.dmsPluginSettingsJson} "$out/DankMaterialShell/plugin_settings.json"
    ''}
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: plugin: ''ln -s ${plugin.src} "$out/DankMaterialShell/plugins/${name}"'') enabledPlugins
    )}
  '';

  dmsWrapper = import ./mk-dms-wrapper.nix {
    inherit lib pkgs dms;
    configDir = dmsConfigDir;
  };

  mangoWrapper = import ./mk-mango-wrapper.nix {
    inherit lib pkgs mango;
    configFile = mangoConfigFile;
    inherit dmsWrapper;
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
    ] ++ extraPackages;
  };
in
{
  inherit mangoWrapper dmsWrapper mangoConfigFile dmsConfigDir;
}
