{ pkgs, dms }:
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
    exec ${dms}/bin/dms "$@"
  '';
}
