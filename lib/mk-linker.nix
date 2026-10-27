{ lib, pkgs, configLinks, dmsSessionFile ? null }:
let
  linkCommands = lib.concatStrings (
    lib.mapAttrsToList (rel: src: ''
      link_config ${lib.escapeShellArg rel} ${lib.escapeShellArg src}
    '') configLinks
  );
in
pkgs.writeShellApplication {
  name = "ojuny-config";
  runtimeInputs = [ pkgs.coreutils ];
  text = ''
    configHome="''${XDG_CONFIG_HOME:-$HOME/.config}"

    link_config() {
      rel="$1"
      src="$2"
      target="$configHome/$rel"
      install -d -m 0755 "$(dirname "$target")"
      staging="$target.ojuny-tmp.$$"
      ln -sfn "$src" "$staging"
      mv -Tf "$staging" "$target"
    }

    seed_session() {
      ${lib.optionalString (dmsSessionFile != null) ''
        stateHome="''${XDG_STATE_HOME:-$HOME/.local/state}"
        install -d -m 0755 "$stateHome/DankMaterialShell"
        if ! cmp -s ${lib.escapeShellArg dmsSessionFile} "$stateHome/DankMaterialShell/session.json"; then
          rm -f "$stateHome/DankMaterialShell/session.json"
          cp ${lib.escapeShellArg dmsSessionFile} "$stateHome/DankMaterialShell/session.json"
        fi
      ''}
    }

    if [ "''${1:-}" = "--seed" ]; then
      seed_session
      exit 0
    fi

    legacyConfig="$configHome/DankMaterialShell"
    if [ -L "$legacyConfig" ]; then
      rm -f "$legacyConfig"
    fi

    ${linkCommands}
    if [ "''${1:-}" = "--links-only" ]; then
      exit 0
    fi

    install -d -m 0755 "$configHome/DankMaterialShell"
    touch "$configHome/DankMaterialShell/.firstlaunch"
    seed_session
  '';
}
