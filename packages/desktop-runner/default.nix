{
  pkgs,
  lib,
  inputs,
  mangowm,
  duxPluginRegistry,
  duxGop,
  duxSearch,
  duxCalendar,
  duxFiles,
  base16Scheme ? "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml",
  ...
}:
let
  mangoDefaults = import ../../lib/defaults/mango.nix;
  duxDefaults = import ../../lib/defaults/dux.nix;
  pluginDefaults = import ../../lib/mk-plugin-defaults.nix {
    inherit lib;
    registry = duxPluginRegistry;
  };
  stylixColors = import ../../lib/stylix-colors.nix { inherit lib; };
  base16Lib = inputs.stylix.inputs.base16.lib { inherit pkgs lib; };
  colors = base16Lib.mkSchemeAttrs base16Scheme;
  wallpaper = "${../../lib/wallpapers/preset-default.png}";
  duxThemeFile = pkgs.writeText "ojuny-dux-theme.json" (
    builtins.toJSON (stylixColors.dankTheme colors)
  );
  ghosttyConfig = import ../../lib/mk-ghostty-config.nix { inherit lib pkgs colors; };
  ghosttyWrapper = import ../../lib/mk-ghostty-wrapper.nix {
    inherit lib pkgs;
    configFile = ghosttyConfig;
  };

  ojuny = import ../../lib/mk-ojuny.nix {
    inherit lib pkgs;
    mango = mangowm;
    dux = inputs.dux-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      mango = mangoDefaults // {
        global = mangoDefaults.global // stylixColors.mangoColors colors;
        binds = lib.recursiveUpdate mangoDefaults.binds {
          common.files.args = "dfiles open";
        };
        execOnce = mangoDefaults.execOnce ++ [ "kdeconnectd" ];
      };
      dux = duxDefaults // {
        settings = duxDefaults.settings // {
          currentThemeName = "custom";
          customThemeFile = "${duxThemeFile}";
        };
        session = {
          configVersion = 7;
          wallpaperPathLight = wallpaper;
          wallpaperPathDark = wallpaper;
        };
      };
      plugins = pluginDefaults.defaults;
      duxClipboard = import ../../lib/defaults/dux-clipboard.nix;
    };
    extraPackages = with pkgs; [
      ghostty
      ghosttyWrapper
      firefox
      duxGop
      duxSearch
      duxCalendar
      duxFiles
    ];
  };
in
pkgs.writeShellApplication {
  name = "ojuny-desktop";
  runtimeInputs = [ pkgs.dbus pkgs.coreutils ];
  text = ''
    root="''${XDG_RUNTIME_DIR:-/tmp}/ojuny-desktop-$$"
    export XDG_CONFIG_HOME="$root/config"
    export XDG_STATE_HOME="$root/state"
    export XDG_CACHE_HOME="$root/cache"
    export XDG_DATA_HOME="$root/data"
    mkdir -p "$XDG_CONFIG_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"

    ${ojuny.configLinker}/bin/ojuny-config

    if [ ! -e /run/opengl-driver ]; then
      export __EGL_VENDOR_LIBRARY_FILENAMES="${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json''${__EGL_VENDOR_LIBRARY_FILENAMES:+:$__EGL_VENDOR_LIBRARY_FILENAMES}"
      export GBM_BACKENDS_PATH="${pkgs.mesa}/lib/gbm''${GBM_BACKENDS_PATH:+:$GBM_BACKENDS_PATH}"
      export LIBGL_DRIVERS_PATH="${pkgs.mesa}/lib/dri''${LIBGL_DRIVERS_PATH:+:$LIBGL_DRIVERS_PATH}"
      export LIBGL_ALWAYS_SOFTWARE="''${LIBGL_ALWAYS_SOFTWARE:-1}"
    fi

    install -d -m 0755 "$XDG_CONFIG_HOME/ghostty"
    ln -sfn ${ghosttyConfig} "$XDG_CONFIG_HOME/ghostty/config"

    exec dbus-run-session --config-file=${pkgs.dbus}/share/dbus-1/session.conf -- ${ojuny.mangoWrapper}/bin/ojuny-mango "$@"
  '';
}
