{ lib, pkgs, mango, configLinker ? null, duxWrapper ? null, runtimeInputs ? [ ] }:
pkgs.writeShellApplication {
  name = "ojuny-mango";
  runtimeInputs = [ mango ] ++ lib.optional (configLinker != null) configLinker ++ lib.optional (duxWrapper != null) duxWrapper ++ runtimeInputs;
  text = ''
    export WLR_RENDERER_ALLOW_SOFTWARE="''${WLR_RENDERER_ALLOW_SOFTWARE:-1}"
    ${lib.optionalString (configLinker != null) "${configLinker}/bin/ojuny-config --links-only"}
    exec ${mango}/bin/mango -c "''${XDG_CONFIG_HOME:-$HOME/.config}/mango/ojuny.toml" "$@"
  '';
}
