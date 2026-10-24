{
  lib,
  pkgs,
  ghostty ? pkgs.ghostty,
  configFile,
}:
pkgs.writeShellApplication {
  name = "ojuny-ghostty";
  runtimeInputs = [
    ghostty
    pkgs.coreutils
  ];
  text = ''
    configHome="''${XDG_CONFIG_HOME:-$HOME/.config}"
    generated=${lib.escapeShellArg (toString configFile)}
    args=(--config-default-files=false --config-file="$generated")

    for userConfig in "$configHome/ghostty/config" "$configHome/ghostty/config.ghostty"; do
      [ -f "$userConfig" ] || continue
      [ "$(readlink -f "$userConfig")" = "$(readlink -f "$generated")" ] && continue
      args+=(--config-file="$userConfig")
    done

    exec ${ghostty}/bin/ghostty "''${args[@]}" "$@"
  '';
}
