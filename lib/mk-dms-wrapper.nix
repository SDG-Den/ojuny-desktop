{ lib, pkgs, dms, configDir }:
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
    exec ${dms}/bin/dms "$@"
  '';
}
