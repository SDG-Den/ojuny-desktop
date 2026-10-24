{
  pkgs,
  lib,
  inputs,
  mangowm,
  base16Scheme ? "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml",
  ...
}:
let
  mangoDefaults = import ../../lib/defaults/mango.nix;
  dmsDefaults = import ../../lib/defaults/dms.nix;
  stylixColors = import ../../lib/stylix-colors.nix { inherit lib; };
  base16Lib = inputs.stylix.inputs.base16.lib { inherit pkgs lib; };
  colors = base16Lib.mkSchemeAttrs base16Scheme;
  wallpaper = "${../../lib/wallpapers/everforest.png}";
  dmsThemeFile = pkgs.writeText "ojuny-dms-theme.json" (
    builtins.toJSON (stylixColors.dankTheme colors)
  );

  ojuny = import ../../lib/mk-ojuny.nix {
    inherit lib pkgs;
    mango = mangowm;
    dms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      mango = mangoDefaults // {
        global = mangoDefaults.global // stylixColors.mangoColors colors;
      };
      dms = dmsDefaults // {
        settings = dmsDefaults.settings // {
          currentThemeName = "custom";
          customThemeFile = "${dmsThemeFile}";
        };
        session = {
          wallpaperPath = wallpaper;
          wallpaperPathLight = wallpaper;
          wallpaperPathDark = wallpaper;
        };
      };
      dmsClipboard = import ../../lib/defaults/dms-clipboard.nix;
    };
    extraPackages = with pkgs; [ ghostty firefox nautilus];
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
    '') ojuny.configLinks)}
    export XDG_CONFIG_HOME="$configHome"
    exec dbus-run-session -- ${ojuny.mangoWrapper}/bin/ojuny-mango "$@"
  '';
}
