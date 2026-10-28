{ lib, ... }:
let
  mangoDefaults = import ./defaults/mango.nix;
  duxDefaults = import ./defaults/dux.nix;
  duxClipboardDefaults = import ./defaults/dux-clipboard.nix;
  barPresetsDefaults = import ./defaults/bar-presets.nix;
  wallpaperPresets = import ./wallpaper-presets.nix;

  inherit (lib) mkEnableOption mkOption types;

  bindModule = types.submodule {
    options = {
      modifier = mkOption {
        type = types.listOf types.str;
        default = [ "SUPER" ];
      };
      keys = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
      dispatcher = mkOption {
        type = types.str;
        default = "spawn";
      };
      args = mkOption {
        type = types.either (types.listOf types.str) types.str;
        default = [ ];
      };
      description = mkOption {
        type = types.str;
        default = "";
      };
      group = mkOption {
        type = types.str;
        default = "Other";
        description = "Cheatsheet group (the top-level filter category).";
      };
      subcat = mkOption {
        type = types.str;
        default = "";
        description = "Cheatsheet category used to sort within the group. Empty omits it.";
      };
    };
  };

  bindGroup = types.attrsOf (types.attrsOf bindModule);

  menuRowModule = types.submodule {
    options = {
      icon = mkOption {
        type = types.str;
        description = "Material icon name.";
      };
      label = mkOption {
        type = types.str;
        description = "Row text.";
      };
      aliases = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Search aliases.";
      };
      provider = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Provider-backed submenu id (e.g. \"apps\").";
      };
      target = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Link target opened when selected.";
      };
      action = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Shell command run on select.";
      };
      title = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      iconFont = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      when = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Shell condition controlling visibility.";
      };
      checked = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Shell condition for the checked state.";
      };
      disabled = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Shell condition that greys the row out.";
      };
    };
  };
in
{
  options.desktop.ojuny = {
    enable = mkEnableOption "Ojuny Desktop (mangoWM + Dux Shell)";

    mango = {
      global = mkOption {
        type = types.toml;
        default = mangoDefaults.global;
        description = "Mango [global] settings (nested attrs are flattened with underscores).";
      };
      env = mkOption {
        type = types.toml;
        default = mangoDefaults.env;
        description = "Mango [env] variables.";
      };
      var = mkOption {
        type = types.toml;
        default = mangoDefaults.var;
        description = "Mango [var] variables.";
      };
      execOnce = mkOption {
        type = types.listOf types.str;
        default = mangoDefaults.execOnce;
        description = "Commands run once at startup.";
      };
      exec = mkOption {
        type = types.listOf types.str;
        default = mangoDefaults.exec;
        description = "Commands run on every config reload.";
      };
      source = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Additional config files to source.";
      };
      rules = mkOption {
        type = types.toml;
        default = mangoDefaults.rules;
        description = "Mango window/tag/layer/monitor/device rules.";
      };
      binds = mkOption {
        type = bindGroup;
        default = mangoDefaults.binds;
        description = "Keybindings, grouped by key mode then by name.";
      };
      mousebind = mkOption {
        type = bindGroup;
        default = mangoDefaults.mousebind;
        description = "Mouse button bindings, grouped by mode then by name.";
      };
      axisbind = mkOption {
        type = bindGroup;
        default = mangoDefaults.axisbind;
        description = "Scroll-axis bindings, grouped by mode then by name.";
      };
      gesturebind = mkOption {
        type = bindGroup;
        default = mangoDefaults.gesturebind;
        description = "Touch gesture bindings, grouped by mode then by name.";
      };
    };

    dux = {
      settings = mkOption {
        type = types.toml;
        default = duxDefaults.settings;
        description = "Dux Shell settings (settings.json). Use the convenience options below for the collection keys (barConfigs, dockConfigs, controlCenterWidgets, dashCards, dashTabs, dashOptions); they override the same keys here.";
      };
      session = mkOption {
        type = types.toml;
        default = { };
        description = "Dux Shell session (session.json seeded into the XDG state directory at login). `wallpaperPathLight` and `wallpaperPathDark` set the shell wallpaper.";
      };
      barConfigs = mkOption {
        type = types.attrsOf types.toml;
        default = duxDefaults.barConfigs;
        description = "Bar configurations keyed by id. Each entry may set `_order` (int, default 1000) to control the generated array order.";
      };
      barPreset = mkOption {
        type = types.enum ((builtins.attrNames barPresetsDefaults.presets) ++ [ "custom" ]);
        default = "default";
        description = "Active bar preset. `custom` uses `barConfigs.custom`, so a downstream repo can override it.";
      };
      barPresets = mkOption {
        type = types.attrsOf types.toml;
        default = barPresetsDefaults.presets;
        internal = true;
        description = "Bundled bar definitions keyed by preset id. `lib/defaults/bar-presets.nix` is the source of truth.";
      };
      dockConfigs = mkOption {
        type = types.attrsOf types.toml;
        default = duxDefaults.dockConfigs;
        description = "Dock configurations keyed by id. Each entry may set `_order` (int, default 1000). Nested `widgets` is itself an id-keyed attrset (with optional `_order`).";
      };
      controlCenterWidgets = mkOption {
        type = types.attrsOf types.toml;
        default = duxDefaults.controlCenterWidgets;
        description = "Control-center widgets keyed by id. Each entry may set `_order` (int, default 1000).";
      };
      dashCards = mkOption {
        type = types.attrsOf types.toml;
        default = duxDefaults.dashCards;
        description = "Dashboard cards keyed by id. Each entry may set `_order` (int, default 1000).";
      };
      dashTabs = mkOption {
        type = types.attrsOf types.toml;
        default = duxDefaults.dashTabs;
        description = "Dashboard tabs keyed by id. Each entry may set `_order` (int, default 1000).";
      };
      dashOptions = mkOption {
        type = types.toml;
        default = duxDefaults.dashOptions;
        description = "Dashboard options. `weather.widgets` is an id-keyed attrset (with optional `_order`).";
      };
      clipboardSettings = mkOption {
        type = types.toml;
        default = duxClipboardDefaults;
        description = "Dux Shell clipboard settings (clsettings.json).";
      };
      managePluginSettings = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to generate plugin_settings.json from dux.plugins.";
      };
      plugins = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to install and enable this plugin.";
            };
            src = mkOption {
              type = types.either types.package types.path;
              description = "Source directory or package of the plugin.";
            };
            settings = mkOption {
              type = types.toml;
              default = { };
              description = "Plugin settings written to plugin_settings.json.";
            };
            dir = mkOption {
              type = types.str;
              default = "";
              description = "Directory name under plugins/ for this plugin's source. Empty means use the attribute key (the Dux Shell plugin id). Set only when the plugin expects a different directory name.";
            };
            config = mkOption {
              type = types.toml;
              default = { };
              description = "Extra configuration written to plugins/<dir>/config.json inside the plugin directory. Empty means no config.json is written.";
            };
          };
        });
        default = { };
        description = "Dux Shell plugins, keyed by plugin name.";
      };
    };

    fileManager = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to install and wire the selected file manager.";
      };
      package = mkOption {
        type = types.enum [ "dux-files" "nautilus" "custom" ];
        default = "dux-files";
        description = "File manager to install. `custom` installs `customPackage` and uses `customCommand` without MIME or portal wiring.";
      };
      customPackage = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = "Package installed when `package = \"custom\"`.";
      };
      customCommand = mkOption {
        type = types.str;
        default = "dfiles open";
        description = "Command run by the file-manager keybind when `package = \"custom\"`.";
      };
      portal = mkOption {
        type = types.bool;
        default = true;
        description = "Register the Dux Files FileChooser portal backend when the selected package is dux-files.";
      };
      command = mkOption {
        type = types.str;
        internal = true;
        default = "";
        description = "Resolved command that opens the selected file manager.";
      };
    };

    defaultApps = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Packages added to the desktop session PATH (terminal, browser, file manager, etc.) so default keybinds can launch them.";
    };

    dankMenu = {
      enable = mkEnableOption "a Nix-managed dankMenu menu (the plugin itself is enabled by default)";
      menu = mkOption {
        type = types.attrsOf menuRowModule;
        default = { };
        description = "dankMenu tree keyed by dotted id (e.g. \"learn.keybinds\"). A non-empty tree overrides the plugin's bundled menu through the menuPath setting.";
      };
      settings = mkOption {
        type = types.toml;
        default = { };
        description = "Additional dankMenu plugin settings merged into plugin_settings.json.";
      };
    };

    wallpaper = {
      preset = mkOption {
        type = types.enum (builtins.attrNames wallpaperPresets);
        default = "everforest";
        description = "Bundled wallpaper preset. Every preset is generated with the active stylix palette.";
      };
      image = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Custom wallpaper image. When set, it overrides the selected preset and is used as-is.";
      };
      userDirectory = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Directory of user wallpaper images to include in the generated wallpaper directory.";
      };
      cycleIncludeBuiltins = mkOption {
        type = types.bool;
        default = true;
        description = "Include the generated bundled presets when Dux Shell cycles through wallpapers.";
      };
      set = mkOption {
        type = types.nullOr types.package;
        default = null;
        internal = true;
        description = "Generated directory holding every themed preset and user wallpaper.";
      };
      directory = mkOption {
        type = types.str;
        default = "";
        internal = true;
        description = "The generated directory Dux Shell reads and cycles through.";
      };
      selected = mkOption {
        type = types.str;
        default = "";
        internal = true;
        description = "The generated path of the selected wallpaper.";
      };
      default = mkOption {
        type = types.str;
        default = "";
        internal = true;
        description = "The generated path of the default preset.";
      };
      presets = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              label = mkOption {
                type = types.str;
                description = "Human-readable preset label.";
              };
              path = mkOption {
                type = types.str;
                description = "Generated path of the themed preset.";
              };
            };
          }
        );
        default = { };
        internal = true;
        description = "Generated metadata for every bundled preset.";
      };
      userWallpapers = mkOption {
        type = types.attrsOf types.str;
        default = { };
        internal = true;
        description = "Generated paths of user wallpapers, keyed by file name.";
      };
    };

    stylix.enable = mkEnableOption "theming mangoWM from the imported stylix palette (requires stylix to be imported separately)";
  };
}
