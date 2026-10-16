{ lib, pkgs, dms, stateDir ? null }:
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
    ${lib.optionalString (stateDir != null) ''export XDG_STATE_HOME="${stateDir}"''}
    exec ${dms}/bin/dms "$@"
  '';
}
