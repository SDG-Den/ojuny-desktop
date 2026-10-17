{ self, inputs, ... }:
{
  flake.modules.nixos.ojuny-desktop = { config, lib, pkgs, options, ... }:
  let
    cfg = config.desktop.ojuny;
    toMenuJson = (import ../../lib/dank-menu.nix { inherit lib; }).toMenuJson;
    menuFile = pkgs.writeText "ojuny-dankmenu.json" (toMenuJson cfg.dankMenu.menu);
    mangoDefaults = import ../../lib/defaults/mango.nix;
    dmsDefaults = import ../../lib/defaults/dms.nix;
    perKeyDefaults = lib.mapAttrs (_: lib.mkDefault);
    stylixColors = import ../../lib/stylix-colors.nix { inherit lib; };
    mangoColors = stylixColors.mangoColors;
    dankThemeFile = pkgs.writeText "ojuny-dms-stylix-theme.json" (
      builtins.toJSON (stylixColors.dankTheme config.lib.stylix.colors)
    );
    mkWallpaper = import ../../lib/mk-wallpaper.nix { inherit lib pkgs; };
    stylixWallpaper = mkWallpaper { colors = config.lib.stylix.colors; };
    stylixAvailable = options ? stylix;
    ojuny = import ../../lib/mk-ojuny.nix {
      inherit lib pkgs;
      mango = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;
      dms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        inherit (cfg) mango;
        dms = {
          settings = cfg.dms.settings;
          session = cfg.dms.session;
          inherit (cfg.dms)
            barConfigs
            dockConfigs
            controlCenterWidgets
            dashCards
            dashTabs
            dashOptions
            ;
        };
        dmsClipboard = cfg.dms.clipboardSettings;
        plugins = cfg.dms.plugins;
        managePluginSettings = cfg.dms.managePluginSettings;
      };
      extraPackages = cfg.defaultApps;
    };

    session = (pkgs.runCommand "ojuny-desktop-session" { } ''
      mkdir -p "$out/share/wayland-sessions"
      cat > "$out/share/wayland-sessions/ojuny.desktop" <<EOF
      [Desktop Entry]
      Name=Ojuny Desktop
      Comment=Ojuny Desktop (mangoWM + DankMaterialShell)
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
      desktop.ojuny.dms.plugins = lib.mkMerge [
        (lib.mapAttrs (_: plugin: { src = lib.mkDefault plugin; }) (
          inputs.dms-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system}
        ))
        {
          nixMonitor = {
            dir = lib.mkDefault "NixMonitor";
            config.generationsCommand = lib.mkDefault [ "sh" "-c" "ls -1 /nix/var/nix/profiles | grep -e 'system-' | wc -l" ];
            config.storeSizeCommand = lib.mkDefault [ "sh" "-c" "du -sh /nix/store 2>/dev/null | cut -f1" ];
            config.gcCommand = lib.mkDefault [ "sh" "-c" "nix-collect-garbage -d 2>&1" ];
            config.localRevisionCommand = lib.mkDefault [ "sh" "-c" "nixos-version --hash 2>/dev/null | cut -c 1-7 || echo 'N/A'" ];
            config.remoteRevisionCommand = lib.mkDefault [ "sh" "-c" "git ls-remote https://github.com/NixOS/nixpkgs.git nixos-unstable 2>/dev/null | cut -c 1-7 || echo 'N/A'" ];
            config.nixpkgsChannel = lib.mkDefault "nixos-unstable";
            config.updateInterval = lib.mkDefault 300;
            config.rebuildCommand = lib.mkDefault [ "sh" "-c" "sudo nixos-rebuild switch --flake .#$(hostname)" ];
          };
        }
        (lib.mkIf cfg.dankMenu.enable {
          dankMenu.enable = true;
          dankMenu.settings = cfg.dankMenu.settings // lib.optionalAttrs (cfg.dankMenu.menu != { }) { menuPath = "${menuFile}"; };
        })
      ];
      desktop.ojuny.defaultApps = lib.mkAfter (with pkgs; [ ghostty firefox nautilus ]);

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
          // lib.optionalAttrs (cfg.stylix.enable && stylixAvailable)
            (mangoColors config.lib.stylix.colors));

      desktop.ojuny.dms.settings = perKeyDefaults
        (dmsDefaults.settings
          // lib.optionalAttrs (cfg.stylix.enable && stylixAvailable) {
            currentThemeName = "custom";
            customThemeFile = "${dankThemeFile}";
            fontFamily = config.stylix.fonts.sansSerif.name;
            monoFontFamily = config.stylix.fonts.monospace.name;
            popupTransparency = config.stylix.opacity.popups;
            dockTransparency = config.stylix.opacity.desktop;
          });

      desktop.ojuny.dms.session = perKeyDefaults
        (lib.optionalAttrs
          (cfg.stylix.enable && stylixAvailable && config.stylix.image != null)
          {
            wallpaperPath = config.stylix.image;
            wallpaperPathLight = config.stylix.image;
            wallpaperPathDark = config.stylix.image;
          });

      environment.systemPackages = [ ojuny.mangoWrapper ] ++ cfg.defaultApps;

      systemd.user.tmpfiles.rules = lib.mapAttrsToList
        (rel: src: "L+ %h/.config/${rel} - - - - ${src}")
        ojuny.dmsConfigLinks;

      systemd.user.services.ojuny-desktop-setup = {
        description = "Prepare the ojuny desktop writable state";
        wantedBy = [ "basic.target" ];
        before = [ "systemd-tmpfiles-setup.service" ];
        unitConfig.DefaultDependencies = false;
        startLimitIntervalSec = 60;
        startLimitBurst = 3;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.writeShellApplication {
            name = "ojuny-desktop-setup";
            runtimeInputs = [ pkgs.coreutils ];
            text = ''
              legacyConfig="$HOME/.config/DankMaterialShell"
              if [ -L "$legacyConfig" ]; then
                rm -f "$legacyConfig"
              fi
              ${lib.optionalString (ojuny.dmsSessionFile != null) ''
                install -d -m 0755 "$HOME/.local/state/DankMaterialShell"
                sessionSeed=${ojuny.dmsSessionFile}
                sessionTarget="$HOME/.local/state/DankMaterialShell/session.json"
                if ! cmp -s "$sessionSeed" "$sessionTarget"; then
                  cp "$sessionSeed" "$sessionTarget"
                fi
              ''}
              install -d -m 0755 "$HOME/.config/DankMaterialShell"
              touch "$HOME/.config/DankMaterialShell/.firstlaunch"
            '';
          }}/bin/ojuny-desktop-setup";
        };
      };

      services.displayManager.sessionPackages = [ session ];

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
        ];
      };

      security.polkit.enable = lib.mkDefault true;
      programs.xwayland.enable = lib.mkDefault true;
      services.graphical-desktop.enable = lib.mkDefault true;
      # gvfs sftp backend: valent (kdeconnect) mounts the device under
      # /run/user/<uid>/gvfs and nautilus reaches the remote over sftp.
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
      stylix.image = lib.mkIf
        (cfg.stylix.enable && options.stylix.base16Scheme.highestPrio < 1500)
        (lib.mkDefault stylixWallpaper);
    });
  };
}
