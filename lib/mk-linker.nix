{ lib, pkgs, configLinks, duxSessionFile ? null }:
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
      ${lib.optionalString (duxSessionFile != null) ''
        stateHome="''${XDG_STATE_HOME:-$HOME/.local/state}"
        target="$stateHome/dms/session.json"
        stamp="$stateHome/dms/.ojuny-session-source"
        source=${lib.escapeShellArg duxSessionFile}
        install -d -m 0755 "$stateHome/dms"
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
      legacyTarget="$(readlink -f "$legacyConfig" 2>/dev/null || true)"
      dmsTarget="$(readlink -f "$configHome/dms" 2>/dev/null || true)"
      if [ "$legacyTarget" != "$dmsTarget" ]; then
        rm -f "$legacyConfig"
      fi
    fi

    ${linkCommands}
    if [ "''${1:-}" = "--links-only" ]; then
      exit 0
    fi

    install -d -m 0755 "$configHome/dms"
    touch "$configHome/dms/.firstlaunch"
    seed_session
  '';
}
