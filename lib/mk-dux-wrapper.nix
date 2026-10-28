{ lib, pkgs, dux, quickshell ? pkgs.quickshell, configLinker ? null }:
assert lib.versionAtLeast quickshell.version "0.3.0";
pkgs.writeShellApplication {
  name = "dms";
  runtimeInputs = [
    dux
    quickshell
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
        ${configLinker}/bin/ojuny-config --seed
      fi
    ''}
    exec ${dux}/bin/dms "$@"
  '';
}
