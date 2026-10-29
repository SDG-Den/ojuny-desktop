{ self, inputs, ... }:
{
  flake.modules.nixos.ojuny-desktop = { config, lib, pkgs, options, ... }:
  let
    cfg = config.desktop.ojuny;
    toMenuJson = (import ../../lib/dank-menu.nix { inherit lib; }).toMenuJson;
    menuFile = pkgs.writeText "ojuny-dankmenu.json" (toMenuJson cfg.dankMenu.menu);
    mangoDefaults = import ../../lib/defaults/mango.nix;
    duxDefaults = import ../../lib/defaults/dux.nix;
    barPresetDefaults = import ../../lib/defaults/bar-presets.nix;
    duxFiles = inputs.dux-files.packages.${pkgs.stdenv.hostPlatform.system}.default;
    fileManager = (import ../../lib/file-manager.nix { inherit lib pkgs; }).resolve {
      inherit (cfg) fileManager;
      inherit duxFiles;
    };
    perKeyDefaults = lib.mapAttrs (_: lib.mkDefault);
    stylixColors = import ../../lib/stylix-colors.nix { inherit lib; };
    wallpaperPresets = import ../../lib/wallpaper-presets.nix;
    mangoColors = stylixColors.mangoColors;
    fallbackColors = stylixColors.everforestDarkHard;
    fallbackThemeFile = pkgs.writeText "ojuny-dux-everforest-theme.json" (
      builtins.toJSON stylixColors.fallbackTheme
    );
    stylixThemeFile = pkgs.writeText "ojuny-dux-stylix-theme.json" (
      builtins.toJSON (stylixColors.dankTheme config.lib.stylix.colors)
    );
    stylixAvailable = options ? stylix;
    useStylixTheme = cfg.stylix.enable && stylixAvailable;
    useFallbackTheme = !stylixAvailable;
    wallpaperSet = import ../../lib/mk-wallpaper-set.nix { inherit lib pkgs; } {
      presets = wallpaperPresets;
      colors =
        if useStylixTheme && options.stylix.base16Scheme.highestPrio < 1500 then
          config.lib.stylix.colors
        else
          fallbackColors;
      userDirectory = cfg.wallpaper.userDirectory;
      selectedPreset = cfg.wallpaper.preset;
      selectedImage = cfg.wallpaper.image;
      cycleIncludeBuiltins = cfg.wallpaper.cycleIncludeBuiltins;
    };
    stylixWallpaper = wallpaperSet.selected;
    sessionWallpaper =
      if useStylixTheme && config.stylix.image != null then
        config.stylix.image
      else
        wallpaperSet.selected;
    pluginDefaults = import ../../lib/mk-plugin-defaults.nix {
      inherit lib;
      registry = inputs.dux-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system};
    };
    ghosttyConfig = import ../../lib/mk-ghostty-config.nix {
      inherit lib pkgs;
      colors = if useStylixTheme then config.lib.stylix.colors else fallbackColors;
    };
    ghosttyWrapper = import ../../lib/mk-ghostty-wrapper.nix {
      inherit lib pkgs;
      configFile = ghosttyConfig;
    };
    ojuny = import ../../lib/mk-ojuny.nix {
      inherit lib pkgs;
      mango = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;
      dux = inputs.dux-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
      quickshell = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.quickshell;
      settings = {
        inherit (cfg) mango;
        dux = {
          settings = cfg.dux.settings;
          session = cfg.dux.session;
          barConfigs = lib.recursiveUpdate duxDefaults.barConfigs cfg.dux.barConfigs;
          inherit (cfg.dux)
            dockConfigs
            controlCenterWidgets
            dashCards
            dashTabs
            dashOptions
            ;
        };
        duxClipboard = cfg.dux.clipboardSettings;
        plugins = cfg.dux.plugins;
        managePluginSettings = cfg.dux.managePluginSettings;
      };
      extraPackages = [ ghosttyWrapper ] ++ cfg.defaultApps;
    };

    session = (pkgs.runCommand "ojuny-desktop-session" { } ''
      mkdir -p "$out/share/wayland-sessions"
      cat > "$out/share/wayland-sessions/ojuny.desktop" <<EOF
      [Desktop Entry]
      Name=Ojuny Desktop
      Comment=Ojuny Desktop (mangoWM + Dux Shell)
      Exec=${ojuny.mangoWrapper}/bin/ojuny-mango
      Type=Application
      DesktopNames=mango;wlroots
      EOF
    '').overrideAttrs (old: {
      passthru = (old.passthru or { }) // {
        providedSessions = [ "ojuny" ];
      };
    });
  in
  {
    imports = [ self.modules.nixos.ojuny-desktop-options ];

    config = lib.mkIf cfg.enable ({
      desktop.ojuny.dux.plugins = lib.mkMerge [
        pluginDefaults.module
        (lib.mkIf cfg.dankMenu.enable {
          dankMenu.settings = lib.mkDefault (
            cfg.dankMenu.settings
            // lib.optionalAttrs (cfg.dankMenu.menu != { }) { menuPath = "${menuFile}"; }
          );
        })
      ];
      desktop.ojuny.defaultApps = lib.mkAfter (
        [
          pkgs.ghostty
          pkgs.firefox
          inputs.dux-gop.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.dux-search.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.dux-calendar.packages.${pkgs.stdenv.hostPlatform.system}.default
          self.packages.${pkgs.stdenv.hostPlatform.system}.ojuny-WinMenu
        ]
        ++ lib.optional (fileManager.package != null) fileManager.package
      );
      desktop.ojuny.fileManager.command = fileManager.command;
      desktop.ojuny.mango.binds = lib.mkDefault (
        lib.recursiveUpdate mangoDefaults.binds {
          common.files.args = fileManager.command;
        }
      );

      desktop.ojuny.dux.barConfigs =
        let
          presetActive = id: id != "none" && cfg.dux.barPreset == id;
        in
        lib.mapAttrs' (
          id: bar:
          lib.nameValuePair id (lib.mkDefault (
            bar // {
              enabled = presetActive id;
              visible = presetActive id;
            }
          ))
        ) (cfg.dux.barPresets // {
          custom = barPresetDefaults.customBase // {
            name = "Custom bar";
            _order = 10;
          };
        });

      desktop.ojuny.mango.execOnce = lib.mkAfter [
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE"
        "systemctl --user reset-failed"
        "systemctl --user start mango-session.target"
      ];

      systemd.user.targets.mango-session = {
        description = "mango compositor session";
        documentation = [ "man:systemd.special(7)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [
          "graphical-session-pre.target"
          "xdg-desktop-autostart.target"
        ];
        after = [ "graphical-session-pre.target" ];
        before = [ "xdg-desktop-autostart.target" ];
      };

      desktop.ojuny.mango.global = perKeyDefaults
        (mangoDefaults.global
          // (
            if useStylixTheme then
              mangoColors config.lib.stylix.colors
            else if useFallbackTheme then
              mangoColors fallbackColors
            else
              { }
          ));

      desktop.ojuny.dux.settings = perKeyDefaults
        ((duxDefaults.settings // { frameEnabled = cfg.dux.barPreset == "caelestia"; })
          // (
            if useStylixTheme then {
              currentThemeName = "custom";
              customThemeFile = "${stylixThemeFile}";
              fontFamily = config.stylix.fonts.sansSerif.name;
              monoFontFamily = config.stylix.fonts.monospace.name;
              displayFontFamily = config.stylix.fonts.sansSerif.name;
              popupTransparency = config.stylix.opacity.popups;
            } else if useFallbackTheme then {
              currentThemeName = "custom";
              customThemeFile = "${fallbackThemeFile}";
            } else
              { }
          )
          // {
            lockScreenWallpaperPath = sessionWallpaper;
          });

      desktop.ojuny.dux.session = perKeyDefaults (
        {
          configVersion = 7;
          wallpaperPath = sessionWallpaper;
        }
        // lib.optionalAttrs (useStylixTheme || useFallbackTheme) {
          wallpaperPathLight = sessionWallpaper;
          wallpaperPathDark = sessionWallpaper;
          wallpaperCyclingFolderPath = wallpaperSet.directory;
          wallpaperCyclingRecursive = wallpaperSet.recursive;
        }
      );

      desktop.ojuny.wallpaper = {
        set = wallpaperSet.set;
        directory = wallpaperSet.directory;
        selected = wallpaperSet.selected;
        default = wallpaperSet.default;
        presets = wallpaperSet.presets;
        userWallpapers = wallpaperSet.userWallpapers;
      };

      environment.systemPackages = [ ojuny.mangoWrapper ] ++ cfg.defaultApps;

      systemd.user.services.ojuny-config = {
        description = "Link the ojuny desktop configuration into the user config directory";
        wantedBy = [ "basic.target" ];
        before = [ "systemd-tmpfiles-setup.service" ];
        unitConfig.DefaultDependencies = false;
        startLimitIntervalSec = 60;
        startLimitBurst = 3;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${ojuny.configLinker}/bin/ojuny-config";
        };
        restartTriggers =
          lib.attrValues ojuny.configLinks
          ++ lib.optional (ojuny.duxSessionFile != null) ojuny.duxSessionFile;
      };

      services.displayManager.sessionPackages = [ session ];
      services.displayManager.defaultSession = lib.mkDefault "ojuny";

      xdg.mime.defaultApplications = lib.mkIf (fileManager.desktopId != null) (lib.mkDefault fileManager.mimeApplications);

      xdg.portal = {
        enable = lib.mkDefault true;
        wlr.enable = lib.mkDefault true;
        wlr.settings.screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.wlr-utils}/bin/wlr-chooser";
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ] ++ lib.optional fileManager.portal duxFiles;
        config.common = lib.mkIf fileManager.portal {
          "org.freedesktop.impl.portal.FileChooser" = [ "dfiles" ];
        };
      };

      systemd.user.services.dfiles = lib.mkIf (cfg.fileManager.enable && cfg.fileManager.package == "dux-files") {
        description = "Dux Files";
        documentation = [ "https://github.com/duxlabs-dev/dux-files" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${duxFiles}/bin/dfiles run --session --hidden --keep-running";
          Restart = "on-failure";
          RestartSec = 2;
          Slice = "app.slice";
        };
      };

      security.polkit.enable = lib.mkDefault true;
      programs.kdeconnect.enable = lib.mkDefault true;
      programs.xwayland.enable = lib.mkDefault true;
      services.graphical-desktop.enable = lib.mkDefault true;
      # gvfs sftp backend: valent (kdeconnect) mounts the device under
      # /run/user/<uid>/gvfs and the configured file manager reaches the remote over sftp.
      services.gvfs.enable = lib.mkDefault true;
      # valent's sftp plugin runs `ssh-add` to register the device key before
      # mounting; without a reachable agent the mount is aborted.
      programs.ssh.startAgent = lib.mkDefault true;
      environment.etc."environment.d/50-ssh-agent.conf".text = ''
        SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
      '';

      assertions = [{
        assertion = !cfg.stylix.enable || stylixAvailable;
        message = "desktop.ojuny.stylix.enable requires the stylix module to be imported (e.g. inputs.stylix.nixosModules.stylix).";
      }];
    } // lib.optionalAttrs (options ? stylix) {
      stylix.image = lib.mkIf cfg.stylix.enable (lib.mkDefault stylixWallpaper);
    });
  };
}
