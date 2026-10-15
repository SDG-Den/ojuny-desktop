{ lib, pkgs, mango, configFile, dmsWrapper ? null, runtimeInputs ? [ ] }:
pkgs.writeShellApplication {
  name = "ojuny-mango";
  runtimeInputs = [ mango ] ++ lib.optional (dmsWrapper != null) dmsWrapper ++ runtimeInputs;
  text = ''
    exec ${mango}/bin/mango -c ${configFile} "$@"
  '';
}
