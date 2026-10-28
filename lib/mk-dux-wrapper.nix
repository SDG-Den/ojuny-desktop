{ lib, pkgs, dux, configLinker ? null }:
assert lib.versionAtLeast pkgs.quickshell.version "0.3.0";
pkgs.writeShellApplication {
  name = "dms";
  runtimeInputs = [
    dux
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
        ${configLinker}/bin/ojuny-config --seed
      fi
    ''}
    exec ${dux}/bin/dms "$@"
  '';
}
