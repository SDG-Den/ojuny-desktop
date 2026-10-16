{ lib, ... }:
let
  mangoDefaults = import ./defaults/mango.nix;
  dmsDefaults = import ./defaults/dms.nix;
  dmsClipboardDefaults = import ./defaults/dms-clipboard.nix;

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
      subcat = mkOption {
        type = types.str;
        default = "General";
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
    enable = mkEnableOption "Ojuny Desktop (mangoWM + DankMaterialShell)";

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

    dms = {
      settings = mkOption {
        type = types.toml;
        default = dmsDefaults.settings;
        description = "DankMaterialShell settings (settings.json). Use the convenience options below for the collection keys (barConfigs, dockConfigs, controlCenterWidgets, dashCards, dashTabs, dashOptions); they override the same keys here.";
      };
      session = mkOption {
        type = types.toml;
        default = { };
        description = "DankMaterialShell session (session.json seeded into the XDG state directory at login). `wallpaperPath`, `wallpaperPathLight` and `wallpaperPathDark` set the shell wallpaper.";
      };
      barConfigs = mkOption {
        type = types.attrsOf types.toml;
        default = dmsDefaults.barConfigs;
        description = "Bar configurations keyed by id. Each entry may set `_order` (int, default 1000) to control the generated array order.";
      };
      dockConfigs = mkOption {
        type = types.attrsOf types.toml;
        default = dmsDefaults.dockConfigs;
        description = "Dock configurations keyed by id. Each entry may set `_order` (int, default 1000). Nested `widgets` is itself an id-keyed attrset (with optional `_order`).";
      };
      controlCenterWidgets = mkOption {
        type = types.attrsOf types.toml;
        default = dmsDefaults.controlCenterWidgets;
        description = "Control-center widgets keyed by id. Each entry may set `_order` (int, default 1000).";
      };
      dashCards = mkOption {
        type = types.attrsOf types.toml;
        default = dmsDefaults.dashCards;
        description = "Dashboard cards keyed by id. Each entry may set `_order` (int, default 1000).";
      };
      dashTabs = mkOption {
        type = types.attrsOf types.toml;
        default = dmsDefaults.dashTabs;
        description = "Dashboard tabs keyed by id. Each entry may set `_order` (int, default 1000).";
      };
      dashOptions = mkOption {
        type = types.toml;
        default = dmsDefaults.dashOptions;
        description = "Dashboard options. `weather.widgets` is an id-keyed attrset (with optional `_order`).";
      };
      clipboardSettings = mkOption {
        type = types.toml;
        default = dmsClipboardDefaults;
        description = "DankMaterialShell clipboard settings (clsettings.json).";
      };
      managePluginSettings = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to generate plugin_settings.json from dms.plugins.";
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
          };
        });
        default = { };
        description = "DankMaterialShell plugins, keyed by plugin name.";
      };
    };

    defaultApps = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Packages added to the desktop session PATH (terminal, browser, file manager, etc.) so default keybinds can launch them.";
    };

    dankMenu = {
      enable = mkEnableOption "the dankMenu plugin with a Nix-managed menu";
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

    stylix.enable = mkEnableOption "theming mangoWM from the imported stylix palette (requires stylix to be imported separately)";
  };
}
