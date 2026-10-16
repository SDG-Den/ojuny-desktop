{
  pkgs,
  lib,
  inputs,
  mangowm,
  ...
}:
let
  ojuny = import ../../lib/mk-ojuny.nix {
    inherit lib pkgs;
    mango = mangowm;
    dms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      mango = import ../../lib/defaults/mango.nix;
      dms = import ../../lib/defaults/dms.nix;
      dmsClipboard = import ../../lib/defaults/dms-clipboard.nix;
    };
    extraPackages = with pkgs; [ ghostty firefox nautilus ];
  };
in
pkgs.writeShellApplication {
  name = "ojuny-desktop";
  runtimeInputs = [ pkgs.dbus pkgs.coreutils ];
  text = ''
    configHome="''${XDG_RUNTIME_DIR:-/tmp}/ojuny-desktop-$$"
    mkdir -p "$configHome"
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (rel: src: ''
      mkdir -p "$configHome/$(dirname ${rel})"
      ln -sfn ${src} "$configHome/${rel}"
    '') ojuny.dmsConfigLinks)}
    export XDG_CONFIG_HOME="$configHome"
    exec dbus-run-session -- ${ojuny.mangoWrapper}/bin/ojuny-mango "$@"
  '';
}
