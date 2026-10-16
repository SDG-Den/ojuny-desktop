{ lib, pkgs, mango, configFile, dmsWrapper ? null, runtimeInputs ? [ ] }:
pkgs.writeShellApplication {
  name = "ojuny-mango";
  runtimeInputs = [ mango ] ++ lib.optional (dmsWrapper != null) dmsWrapper ++ runtimeInputs;
  text = ''
    export WLR_RENDERER_ALLOW_SOFTWARE="''${WLR_RENDERER_ALLOW_SOFTWARE:-1}"
    exec ${mango}/bin/mango -c ${configFile} "$@"
  '';
}
