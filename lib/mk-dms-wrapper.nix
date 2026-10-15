{ lib, pkgs, dms, configDir }:
pkgs.writeShellApplication {
  name = "dms";
  runtimeInputs = [ dms ];
  text = ''
    export XDG_CONFIG_HOME="${configDir}"
    exec ${dms}/bin/dms "$@"
  '';
}
