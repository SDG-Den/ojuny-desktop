{ lib, pkgs, dms, configDir, stateDir ? null }:
pkgs.writeShellApplication {
  name = "dms";
  runtimeInputs = [
    dms
    pkgs.quickshell
    pkgs.shared-mime-info
    pkgs.glib
    pkgs.networkmanager
    pkgs.matugen
    pkgs.cava
    pkgs.khal
  ];
  text = ''
    export XDG_CONFIG_HOME="${configDir}"
    ${lib.optionalString (stateDir != null) ''export XDG_STATE_HOME="${stateDir}"''}
    exec ${dms}/bin/dms "$@"
  '';
}
