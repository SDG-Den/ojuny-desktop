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
        target="$stateHome/DankMaterialShell/session.json"
        stamp="$stateHome/DankMaterialShell/.ojuny-session-source"
        source=${lib.escapeShellArg dmsSessionFile}
        install -d -m 0755 "$stateHome/DankMaterialShell"
        if [ -L "$target" ] || [ ! -e "$target" ] || [ "$(cat "$stamp" 2>/dev/null)" != "$source" ]; then
          rm -f "$target"
          install -m 0644 "$source" "$target"
          printf '%s\n' "$source" > "$stamp"
          chmod 0644 "$stamp"
        else
          chmod u+w "$target" 2>/dev/null || true
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
