{ self, inputs, ... }:
{
  flake.modules.homeManager.ojuny-desktop =
    {
      config,
      lib,
      pkgs,
      options,
      osConfig ? { },
      ...
    }:
    let
      cfg = config.desktop.ojuny;
      dankMenu = osConfig.desktop.ojuny.dankMenu or cfg.dankMenu;
      toMenuJson = (import ../../lib/dank-menu.nix { inherit lib; }).toMenuJson;
      menuFile = pkgs.writeText "ojuny-dankmenu.json" (toMenuJson dankMenu.menu);
      mangoDefaults = import ../../lib/defaults/mango.nix;
      duxDefaults = import ../../lib/defaults/dux.nix;
      barPresetDefaults = import ../../lib/defaults/bar-presets.nix;
      duxFiles = inputs.dux-files.packages.${pkgs.stdenv.hostPlatform.system}.default;
      fileManager = (import ../../lib/file-manager.nix { inherit lib pkgs; }).resolve {
        inherit (cfg) fileManager;
        inherit duxFiles;
      };
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
        extraPackages = [ ghosttyWrapper ] ++ cfg.defaultApps ++ lib.optional (fileManager.package != null) fileManager.package;
      };

      sessionScript = pkgs.writeShellApplication {
        name = "ojuny-hm-session";
        text = ''
          if [ -r "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh" ]; then
            # shellcheck source=/dev/null
            . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
          fi
          exec ${ojuny.mangoWrapper}/bin/ojuny-mango "$@"
        '';
      };

      session = pkgs.runCommand "ojuny-desktop-session-hm" { } ''
        mkdir -p "$out/share/wayland-sessions"
        cat > "$out/share/wayland-sessions/ojuny.desktop" <<EOF
        [Desktop Entry]
        Name=Ojuny Desktop
        Comment=Ojuny Desktop (mangoWM + Dux Shell, Home Manager)
        Exec=${sessionScript}/bin/ojuny-hm-session
        TryExec=${sessionScript}/bin/ojuny-hm-session
        Type=Application
        DesktopNames=mango;wlroots
        EOF
      '';
    in
    {
      imports = [ self.modules.homeManager.ojuny-desktop-options ];

      config = lib.mkIf cfg.enable (
        {
          desktop.ojuny.dux.plugins = lib.mkMerge [
            pluginDefaults.module
            (lib.mkIf (dankMenu.enable or cfg.dankMenu.enable) {
              dankMenu.settings = lib.mkDefault (
                dankMenu.settings // lib.optionalAttrs (dankMenu.menu != { }) { menuPath = "${menuFile}"; }
              );
            })
          ];
          desktop.ojuny.defaultApps = lib.mkDefault (
            with pkgs;
            [
              ghostty
              firefox
              inputs.dux-gop.packages.${pkgs.stdenv.hostPlatform.system}.default
              inputs.dux-search.packages.${pkgs.stdenv.hostPlatform.system}.default
              inputs.dux-calendar.packages.${pkgs.stdenv.hostPlatform.system}.default
              self.packages.${pkgs.stdenv.hostPlatform.system}.ojuny-WinMenu
            ]
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
            Unit = {
              Description = "mango compositor session";
              Documentation = [ "man:systemd.special(7)" ];
              BindsTo = [ "graphical-session.target" ];
              Wants = [
                "graphical-session-pre.target"
                "xdg-desktop-autostart.target"
              ];
              After = [ "graphical-session-pre.target" ];
              Before = [ "xdg-desktop-autostart.target" ];
            };
          };

          desktop.ojuny.mango.global = lib.mkIf (useStylixTheme || useFallbackTheme) (
            lib.mkDefault (
              mangoDefaults.global
              // (if useStylixTheme then mangoColors config.lib.stylix.colors else mangoColors fallbackColors)
            )
          );

          desktop.ojuny.dux.settings = lib.mkMerge [
            { frameEnabled = lib.mkDefault (cfg.dux.barPreset == "caelestia"); }
            (lib.mkIf (useStylixTheme || useFallbackTheme) (
              lib.mkDefault (
                duxDefaults.settings
                // (
                  if useStylixTheme then
                    {
                      currentThemeName = "custom";
                      customThemeFile = "${stylixThemeFile}";
                      fontFamily = config.stylix.fonts.sansSerif.name;
                      monoFontFamily = config.stylix.fonts.monospace.name;
                      displayFontFamily = config.stylix.fonts.sansSerif.name;
                      popupTransparency = config.stylix.opacity.popups;
                    }
                  else
                    {
                      currentThemeName = "custom";
                      customThemeFile = "${fallbackThemeFile}";
                    }
                )
                // {
                  lockScreenWallpaperPath = sessionWallpaper;
                }
              )
            ))
          ];

          desktop.ojuny.dux.session = lib.mkDefault (
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

          home.packages = [
            ojuny.mangoWrapper
            session
          ]
          ++ cfg.defaultApps
          ++ lib.optional (fileManager.package != null) fileManager.package;

          services.kdeconnect.enable = lib.mkDefault true;

          xdg.configFile = lib.mapAttrs' (
            rel: src: lib.nameValuePair rel { source = src; }
          ) ojuny.configLinks;

          home.activation.ojunyDuxFirstLaunch = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            $DRY_RUN_CMD install -d -m 0755 "${config.xdg.configHome}/dms"
            $DRY_RUN_CMD touch "${config.xdg.configHome}/dms/.firstlaunch"
          '';

          xdg.mime.defaultApplications = lib.mkIf (fileManager.desktopId != null) (lib.mkDefault fileManager.mimeApplications);

          xdg.portal = {
            extraPortals = lib.mkIf fileManager.portal [ duxFiles ];
            config.common = lib.mkIf fileManager.portal {
              "org.freedesktop.impl.portal.FileChooser" = [ "dfiles" ];
            };
          };

          systemd.user.services.dfiles = lib.mkIf (cfg.fileManager.enable && cfg.fileManager.package == "dux-files") {
            Unit = {
              Description = "Dux Files";
              Documentation = [ "https://github.com/duxlabs-dev/dux-files" ];
              After = [ "graphical-session.target" ];
              PartOf = [ "graphical-session.target" ];
            };
            Service = {
              Type = "simple";
              ExecStart = "${duxFiles}/bin/dfiles run --session --hidden --keep-running";
              Restart = "on-failure";
              RestartSec = 2;
              Slice = "app.slice";
            };
            Install.WantedBy = [ "graphical-session.target" ];
          };

          systemd.user.services.ojuny-config = {
            Unit = {
              Description = "Seed the ojuny Dux Shell session";
            };
            Service = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${ojuny.configLinker}/bin/ojuny-config --seed";
            };
            Install.WantedBy = [ "basic.target" ];
          };

          assertions = [
            {
              assertion = !cfg.stylix.enable || stylixAvailable;
              message = "desktop.ojuny.stylix.enable requires the stylix module to be imported (e.g. inputs.stylix.homeManagerModules.stylix).";
            }
          ];
        }
        // lib.optionalAttrs (options ? stylix) {
          stylix.image = lib.mkIf cfg.stylix.enable (lib.mkDefault stylixWallpaper);
        }
      );
    };
}
