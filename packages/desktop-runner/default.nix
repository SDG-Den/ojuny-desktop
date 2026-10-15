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
  runtimeInputs = [ pkgs.dbus ];
  text = ''
    exec dbus-run-session -- ${ojuny.mangoWrapper}/bin/ojuny-mango "$@"
  '';
}
