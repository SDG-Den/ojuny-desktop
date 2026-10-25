{ lib, pkgs, dms, configLinker ? null }:
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
    ${lib.optionalString (configLinker != null) ''
      if [ "''${1:-}" = "run" ]; then
        ${configLinker}/bin/ojuny-config --seed || true
      fi
    ''}
    exec ${dms}/bin/dms "$@"
  '';
}
