# ojuny-desktop Options Reference

All options are under `desktop.ojuny.*`. This document describes every exposed option and their defaults.

## Top level

- `desktop.ojuny.enable` (bool, default: false) — Whether to enable Ojuny Desktop (mangoWM + DankMaterialShell).
- `desktop.ojuny.defaultApps` (listOf package, default: []) — Packages added to the desktop session PATH so default keybinds can launch them.
- `desktop.ojuny.stylix.enable` (bool, default: false) — Theme mango from imported stylix palette (requires stylix module).

## mango
- desktop.ojuny.mango.axisbind (type: see defaults/schema)
- desktop.ojuny.mango.binds (type: see defaults/schema)
- desktop.ojuny.mango.env (type: see defaults/schema)
- desktop.ojuny.mango.exec (type: see defaults/schema)
- desktop.ojuny.mango.execOnce (type: see defaults/schema)
- desktop.ojuny.mango.gesturebind (type: see defaults/schema)
- desktop.ojuny.mango.global (type: see defaults/schema)
- desktop.ojuny.mango.mousebind (type: see defaults/schema)
- desktop.ojuny.mango.rules (type: see defaults/schema)
- desktop.ojuny.mango.source (type: see defaults/schema)
- desktop.ojuny.mango.var (type: see defaults/schema)


## `desktop.ojuny.mango.global`

- type: either (attrs; flattened to TOML [global])
- description: Mango [global] settings (nested attrs are flattened with underscores). All keys from defaults are supported.

### Full global keys (from lib/defaults/mango.nix)

- allow_lock_transparent
- animation_duration_close
- animation_duration_focus
- animation_duration_move
- animation_duration_open
- animation_duration_tag
- animation_fade_in
- animation_fade_out
- animation_type_close
- animation_type_open
- animations
- axis_bind_apply_timeout
- blur
- blur_layer
- blur_optimized
- blur_params_brightness
- blur_params_contrast
- blur_params_noise
- blur_params_num_passes
- blur_params_radius
- blur_params_saturation
- border_px
- border_radius
- center_master_overspread
- center_when_single_stack
- default_master_count
- default_master_factor
- disable_trackpad
- drag_lock
- dwindle_drop_simple_split
- dwindle_horizontal_split
- dwindle_manual_split
- dwindle_preserve_split
- dwindle_smart_resize
- dwindle_smart_split
- dwindle_split_ratio
- dwindle_vertical_split
- edge_scroller_focus_allow_speed
- edge_scroller_pointer_focus
- enable_floating_snap
- enable_hotarea
- exchange_cross_monitor
- fade_in_begin_opacity
- fade_out_begin_opacity
- focus_cross_monitor
- focus_on_activate
- focused_opacity
- gap_inner_horizontal
- gap_inner_vertical
- gap_outer_horizontal
- gap_outer_vertical
- group_bar_decorate_border_width
- group_bar_decorate_corner_radius
- group_bar_decorate_font_desc
- group_bar_decorate_padding_x
- group_bar_decorate_padding_y
- group_bar_height
- hotarea_size
- jump_label_decorate_border_width
- jump_label_decorate_corner_radius
- jump_label_decorate_font_desc
- jump_label_decorate_padding_x
- jump_label_decorate_padding_y
- layer_animation_type_close
- layer_animation_type_open
- layer_animations
- mouse_accel_profile
- mouse_accel_speed
- mouse_left_handed
- mouse_natural_scrolling
- new_is_master
- no_border_when_single
- no_radius_when_single
- numlock_on
- repeat_delay
- repeat_rate
- scratchpad_cross_monitor
- scroller_default_proportion
- scroller_default_proportion_single
- scroller_focus_center
- scroller_ignore_proportion_single
- scroller_prefer_center
- scroller_prefer_overspread
- scroller_proportion_preset
- scroller_structs
- shadows
- single_scratchpad
- sloppy_focus
- smart_gaps
- snap_distance
- special_dim
- special_gap_inner_horizontal
- special_gap_inner_vertical
- special_gap_outer_horizontal
- special_gap_outer_vertical
- swipe_min_threshold
- tab_bar_decorate_border_width
- tab_bar_decorate_corner_radius
- tab_bar_decorate_font_desc
- tab_bar_decorate_padding_x
- tab_bar_decorate_padding_y
- tab_bar_height
- tag_animation_direction
- tag_gather
- tag_num
- tap_and_drag
- tap_to_click
- touch_enable
- touch_enable_mouse_emulation
- trackpad_accel_profile
- trackpad_accel_speed
- trackpad_click_method
- trackpad_disable_while_typing
- trackpad_left_handed
- trackpad_middle_button_emulation
- trackpad_natural_scrolling
- trackpad_scroll_factor
- trackpad_scroll_method
- unfocused_opacity
- view_current_to_back
- warp_cursor
- xkb_rules_layout
- zoom_end_ratio
- zoom_initial_ratio


## `desktop.ojuny.mango.exec`

- type: listOf, default: []
- description: Commands run on every config reload.


## `desktop.ojuny.mango.execOnce`

- type: listOf, default: ["dms run", "wl-clip-persist --clipboard both", "wl-paste --type text --watch cliphist store", "wl-paste --type image --watch cliphist store"]
- description: Commands run once at startup.


## `desktop.ojuny.mango.source`

- type: listOf, default: []
- description: Additional config files to source.


## `desktop.ojuny.mango.var`

- type: either, default: {}
- description: Mango [var] variables.


## `desktop.ojuny.mango.env`

- type: either, default: {"MOZ_ENABLE_WAYLAND": "1", "NIXOS_OZONE_WL": "1", "OZONE_PLATFORM": "wayland", "QT_QPA_PLATFORM": "wayland;xcb", "XDG_CURRENT_DESKTOP": "wlroots", "XDG_SESSION_DESKTOP": "wlroots"}
- description: Mango [env] variables.


## `desktop.ojuny.mango.rules`

- type: either, default: {"device_rule": [], "layer_rule": [], "monitor_rule": [], "tag_rule": [{"id": 0, "layout_name": "dwindle"}], "window_rule": [{"app_id": "foot", "focused_opacity": 0.7, "unfocused_opacity": 0.7}, {"height": 0.6, "is_floating": 1, "title": "Floating-Menu", "width": 0.6}]}
- description: Mango window/tag/layer/monitor/device rules.


## `desktop.ojuny.mango.binds`

- type: attrsOf (attrsOf attrsOf bind), default: large nested set
- description: Keybindings, grouped by key mode then by name.

### Structure

```nix
desktop.ojuny.mango.binds.<mode>.<name> = {
  modifier = ["SUPER"];  # list of strings
  keys = ["r"];          # list of strings
  dispatcher = "spawn";    # string
  args = [] or "...";       # list or string
  description = "...";     # string
  subcat = "General";      # string
};
```

See `lib/defaults/mango.nix` for the full default bind tree (many modes/entries).


## `desktop.ojuny.mango.mousebind`

- type: attrsOf (attrsOf attrsOf bind), default: large nested set
- description: Mouse button bindings, grouped by mode then by name.

### Structure

```nix
desktop.ojuny.mango.mousebind.<mode>.<name> = {
  modifier = ["SUPER"];  # list of strings
  keys = ["r"];          # list of strings
  dispatcher = "spawn";    # string
  args = [] or "...";       # list or string
  description = "...";     # string
  subcat = "General";      # string
};
```

See `lib/defaults/mango.nix` for the full default bind tree (many modes/entries).


## `desktop.ojuny.mango.axisbind`

- type: attrsOf (attrsOf attrsOf bind), default: large nested set
- description: Scroll-axis bindings, grouped by mode then by name.

### Structure

```nix
desktop.ojuny.mango.axisbind.<mode>.<name> = {
  modifier = ["SUPER"];  # list of strings
  keys = ["r"];          # list of strings
  dispatcher = "spawn";    # string
  args = [] or "...";       # list or string
  description = "...";     # string
  subcat = "General";      # string
};
```

See `lib/defaults/mango.nix` for the full default bind tree (many modes/entries).


## `desktop.ojuny.mango.gesturebind`

- type: attrsOf (attrsOf attrsOf bind), default: large nested set
- description: Touch gesture bindings, grouped by mode then by name.

### Structure

```nix
desktop.ojuny.mango.gesturebind.<mode>.<name> = {
  modifier = ["SUPER"];  # list of strings
  keys = ["r"];          # list of strings
  dispatcher = "spawn";    # string
  args = [] or "...";       # list or string
  description = "...";     # string
  subcat = "General";      # string
};
```

See `lib/defaults/mango.nix` for the full default bind tree (many modes/entries).


## `desktop.ojuny.dms`

- `desktop.ojuny.dms.settings` (type: either) — DankMaterialShell settings (settings.json) scalar/attr keys. The collection keys are exposed through the convenience options below, which override the same keys here.
- `desktop.ojuny.dms.barConfigs` (type: attrsOf, default per below) — Bar configurations keyed by id.
- `desktop.ojuny.dms.dockConfigs` (type: attrsOf, default per below) — Dock configurations keyed by id.
- `desktop.ojuny.dms.controlCenterWidgets` (type: attrsOf, default per below) — Control-center widgets keyed by id.
- `desktop.ojuny.dms.dashCards` (type: attrsOf, default per below) — Dashboard cards keyed by id.
- `desktop.ojuny.dms.dashTabs` (type: attrsOf, default per below) — Dashboard tabs keyed by id.
- `desktop.ojuny.dms.dashOptions` (type: either, default per below) — Dashboard options; `weather.widgets` is id-keyed.
- `desktop.ojuny.dms.clipboardSettings` (type: either) — DankMaterialShell clipboard settings (clsettings.json).
- `desktop.ojuny.dms.managePluginSettings` (type: bool, default: true) — Whether to generate plugin_settings.json from dms.plugins.

Ordering and shape for the collection options:

- Each collection is an attrset keyed by id (GUI-friendly) instead of a list of attrsets.
- Each entry may set `_order` (int, default 1000). Entries are emitted as an array sorted by `_order`; ties are broken alphabetically by id.
- The entry's attribute key becomes the entry `id` in the generated JSON.
- Nested widget lists (`barConfigs.<id>.leftWidgets`, `barConfigs.<id>.rightWidgets`, `dockConfigs.<id>.widgets`, `dashOptions.weather.widgets`) are also id-keyed attrsets with the same `_order` behaviour.
- Raw array forms for these keys are ignored when the convenience option is set (the convenience option always wins).

`desktop.ojuny.dms.settings` top-level keys (22):

- `animationDuration`
- `barElevationEnabled`
- `builtInPluginSettings`
- `configVersion`
- `dmsWindowsFloatingSeeded`
- `launcherStyle`
- `modalAnimationDuration`
- `motionEffect`
- `muxType`
- `notificationAnimationDuration`
- `notificationBodyFontSize`
- `notificationCompactMode`
- `notificationFocusedMonitor`
- `notificationOverlayEnabled`
- `notificationShowTimeoutBar`
- `notificationSummaryFontSize`
- `osdAlwaysShowValue`
- `popoutAnimationDuration`
- `spotlightBarShowModeChips`
- `syncComponentAnimationSpeeds`
- `systemTrayIconTintMode`
- `widgetBackgroundColor`


## `desktop.ojuny.dms.settings` — Full default structure

```nix
{
  "animationDuration": 350,
  "barElevationEnabled": false,
  "builtInPluginSettings": {
    "dms_clipboard_search": {
      "trigger": "cb"
    },
    "dms_power": {
      "trigger": "pw"
    },
    "dms_qr_generator": {
      "trigger": "qrg"
    },
    "dms_settings_search": {
      "trigger": "?"
    }
  },
  "configVersion": 36,
  "dmsWindowsFloatingSeeded": [
    "mango",
    "mango"
  ],
  "launcherStyle": "island",
  "modalAnimationDuration": 231,
  "motionEffect": 1,
  "muxType": "zellij",
  "notificationAnimationDuration": 400,
  "notificationBodyFontSize": 10,
  "notificationCompactMode": true,
  "notificationFocusedMonitor": true,
  "notificationOverlayEnabled": true,
  "notificationShowTimeoutBar": true,
  "notificationSummaryFontSize": 16,
  "osdAlwaysShowValue": true,
  "popoutAnimationDuration": 476,
  "spotlightBarShowModeChips": true,
  "syncComponentAnimationSpeeds": false,
  "systemTrayIconTintMode": "primary",
  "widgetBackgroundColor": "sch"
}
```
## `desktop.ojuny.dms.barConfigs` — Full default structure

attrset keyed by bar id. Nested `leftWidgets`/`rightWidgets` are id-keyed attrsets.

```nix
{
  "default": {
    "_order": 10,
    "attachToScreenEdge": false,
    "autoHide": false,
    "autoHideDelay": 250,
    "borderColor": "primary",
    "borderEnabled": false,
    "borderOpacity": 1,
    "borderThickness": 1,
    "bottomGap": 0,
    "centerWidgets": [
      "music",
      "clock",
      "weather"
    ],
    "enabled": true,
    "fontScale": 0.9,
    "gothCornerRadiusOverride": false,
    "gothCornerRadiusValue": 12,
    "gothCornersEnabled": false,
    "iconScale": 0.9,
    "innerPadding": 0,
    "island": true,
    "islandCompactThickness": 31,
    "islandGothCornerRadiusOverride": false,
    "islandGothCornerRadiusValue": 20,
    "islandGothCornersEnabled": false,
    "islandHoverCloseDelay": 350,
    "islandHoverOpenDelay": 350,
    "islandOuterGap": 3,
    "islandSatelliteGap": 8,
    "islandSatelliteHoverGap": 5,
    "islandSatelliteHoverSize": 30,
    "islandSatelliteHoverSizeExpanded": 24,
    "islandSatelliteSize": 26,
    "islandSatelliteSizeExpanded": 20,
    "islandWidgetOutlineColor": "surfaceText",
    "islandWidgetOutlineEnabled": true,
    "islandWidgetOutlineOpacity": 0.5,
    "islandWidgetPadding": 0,
    "leftWidgets": {
      "dankKDEConnect": {
        "_order": 20,
        "enabled": true
      },
      "layout": {
        "_order": 30,
        "enabled": true
      },
      "scratchpadHelper": {
        "_order": 40,
        "enabled": true
      },
      "workspaceSwitcher": {
        "_order": 10,
        "dwlShowAllTags": false,
        "enabled": true,
        "showOccupiedWorkspacesOnly": true,
        "showWorkspaceIndex": true,
        "showWorkspacePadding": true,
        "workspacePaddingCount": 5
      }
    },
    "name": "Main Bar",
    "noBackground": false,
    "openOnOverview": false,
    "popupGapsAuto": true,
    "popupGapsManual": 4,
    "position": 0,
    "rightWidgets": {
      "clipboard": {
        "_order": 20
      },
      "controlCenterButton": {
        "_order": 60,
        "enabled": true,
        "showAudioPercent": true,
        "showBatteryIcon": true,
        "showBrightnessIcon": true,
        "showBrightnessPercent": true,
        "showDoNotDisturbIcon": true,
        "showIdleInhibitorIcon": true,
        "showMicIcon": true,
        "showMicPercent": true
      },
      "developerUtilities": {
        "_order": 30,
        "enabled": true
      },
      "localServices": {
        "_order": 50,
        "enabled": true
      },
      "nixMonitor": {
        "_order": 40,
        "enabled": true
      },
      "systemTray": {
        "_order": 10
      }
    },
    "screenPreferences": [
      "all"
    ],
    "shadowIntensity": 0,
    "shadowOpacity": 60,
    "showOnLastDisplay": true,
    "spacing": 0,
    "squareCorners": true,
    "transparency": 1,
    "useOverlayLayer": false,
    "visible": true,
    "widgetOutlineEnabled": true,
    "widgetPadding": 9,
    "widgetTransparency": 1
  }
}
```

Each entry and each widget entry may set `_order` (int, default 1000) to control array order.

## `desktop.ojuny.dms.dockConfigs` — Full default structure

attrset keyed by dock id. Nested `widgets` is an id-keyed attrset.

```nix
{
  "dock": {
    "_order": 10,
    "autoHide": false,
    "borderColor": "secondary",
    "borderEnabled": true,
    "borderOpacity": 1,
    "borderThickness": 1,
    "bottomGap": 0,
    "editOnRightClick": false,
    "enabled": false,
    "followInterfaceStyle": true,
    "groupByApp": true,
    "iconSize": 40,
    "indicatorStyle": "line",
    "isolateDisplays": true,
    "itemSpacing": 4,
    "launcherEnabled": true,
    "launcherLogoBrightness": 0.5,
    "launcherLogoColorOverride": "primary",
    "launcherLogoContrast": 1,
    "launcherLogoCustomPath": "",
    "launcherLogoMode": "os",
    "launcherLogoSizeOffset": 0,
    "magnification": false,
    "magnificationProfile": "parabolic",
    "magnificationScale": 130,
    "margin": 0,
    "maxVisibleApps": 0,
    "maxVisibleRunningApps": 0,
    "mode": "compact",
    "name": "Dock",
    "openOnOverview": false,
    "order": [],
    "position": 1,
    "restoreSpecialWorkspaceOnClick": false,
    "screenPreferences": [
      "all"
    ],
    "separatePinnedAndRunningApps": true,
    "showOnFullscreen": false,
    "showOnLastDisplay": true,
    "showOverflowBadge": true,
    "showTrash": false,
    "smartAutoHide": false,
    "spacing": 7,
    "taskbarAlign": "center",
    "transparency": 1,
    "trashCustomCommand": "",
    "trashFileManager": "default",
    "useOverlayLayer": true,
    "widgetExpansion": "popout",
    "widgets": {
      "dock_apps": {
        "_order": 20,
        "enabled": true,
        "widgetId": "appsDock"
      },
      "dock_launcher": {
        "_order": 10,
        "enabled": true,
        "widgetId": "dockLauncher"
      },
      "dock_trash": {
        "_order": 30,
        "enabled": true,
        "widgetId": "dockTrash"
      }
    }
  }
}
```

Note: the DMS field `order` (a list of app ids) is a separate field from `_order`.

## `desktop.ojuny.dms.controlCenterWidgets` — Full default structure

attrset keyed by widget id.

```nix
{
  "battery": {
    "_order": 20,
    "col": 4,
    "enabled": true,
    "h": 1,
    "row": 0,
    "w": 1
  },
  "bluetooth": {
    "_order": 100,
    "col": 3,
    "enabled": true,
    "h": 1,
    "row": 2,
    "w": 5
  },
  "brightnessSlider": {
    "_order": 60,
    "col": 0,
    "enabled": true,
    "h": 5,
    "row": 1,
    "w": 1
  },
  "builtin_vpn": {
    "_order": 110,
    "col": 3,
    "enabled": true,
    "h": 1,
    "row": 3,
    "w": 5
  },
  "diskUsage": {
    "_order": 130,
    "col": 3,
    "enabled": true,
    "h": 1,
    "mountpath": "/",
    "row": 5,
    "w": 5
  },
  "doNotDisturb": {
    "_order": 150,
    "col": 4,
    "enabled": true,
    "footer": true,
    "footerW": 1,
    "h": 1,
    "row": 7,
    "w": 2
  },
  "idleInhibitor": {
    "_order": 160,
    "col": 4,
    "enabled": true,
    "footer": true,
    "footerW": 1,
    "h": 1,
    "row": 6,
    "w": 2
  },
  "inputVolumeSlider": {
    "_order": 80,
    "col": 2,
    "enabled": true,
    "h": 5,
    "row": 1,
    "w": 1
  },
  "lock": {
    "_order": 40,
    "col": 6,
    "enabled": true,
    "h": 1,
    "row": 0,
    "small": true,
    "w": 1
  },
  "nightMode": {
    "_order": 140,
    "col": 4,
    "enabled": true,
    "footer": true,
    "footerW": 1,
    "h": 1,
    "row": 6,
    "w": 2
  },
  "plugin_dankKDEConnect": {
    "_order": 120,
    "col": 3,
    "enabled": true,
    "h": 1,
    "row": 4,
    "w": 5
  },
  "power": {
    "_order": 50,
    "col": 7,
    "enabled": true,
    "h": 1,
    "row": 0,
    "small": true,
    "w": 1
  },
  "runningApps": {
    "_order": 170,
    "enabled": true,
    "footer": true,
    "h": 1,
    "w": 4
  },
  "settings": {
    "_order": 30,
    "col": 5,
    "enabled": true,
    "h": 1,
    "row": 0,
    "small": true,
    "w": 1
  },
  "user": {
    "_order": 10,
    "col": 0,
    "enabled": true,
    "h": 1,
    "row": 0,
    "w": 4
  },
  "volumeSlider": {
    "_order": 70,
    "col": 1,
    "enabled": true,
    "h": 5,
    "row": 1,
    "w": 1
  },
  "wifi": {
    "_order": 90,
    "col": 3,
    "enabled": true,
    "h": 1,
    "row": 1,
    "w": 5
  }
}
```

## `desktop.ojuny.dms.dashCards` — Full default structure

attrset keyed by card id.

```nix
{
  "calendar": {
    "_order": 40,
    "col": 0,
    "h": 3,
    "row": 1,
    "w": 3
  },
  "clock": {
    "_order": 10,
    "col": 2,
    "h": 1,
    "row": 0,
    "w": 1
  },
  "media": {
    "_order": 50,
    "col": 3,
    "h": 1,
    "row": 3,
    "w": 3
  },
  "network": {
    "_order": 70,
    "col": 3,
    "h": 1,
    "row": 2,
    "w": 3
  },
  "notifications": {
    "_order": 30,
    "col": 0,
    "h": 2,
    "row": 4,
    "w": 6
  },
  "sysmon": {
    "_order": 60,
    "col": 3,
    "h": 1,
    "row": 1,
    "w": 3
  },
  "user": {
    "_order": 80,
    "col": 3,
    "h": 1,
    "row": 0,
    "w": 3
  },
  "weather": {
    "_order": 20,
    "col": 0,
    "h": 1,
    "row": 0,
    "w": 2
  }
}
```

## `desktop.ojuny.dms.dashTabs` — Full default structure

attrset keyed by tab id.

```nix
{
  "media": {
    "_order": 20,
    "enabled": true
  },
  "notifications": {
    "_order": 60,
    "enabled": true
  },
  "overview": {
    "_order": 10,
    "enabled": false
  },
  "wallpaper": {
    "_order": 30,
    "enabled": true
  },
  "weather": {
    "_order": 40,
    "enabled": true
  },
  "wellbeing": {
    "_order": 50,
    "enabled": true
  }
}
```

## `desktop.ojuny.dms.dashOptions` — Full default structure

attrset; `weather.widgets` is an id-keyed attrset.

```nix
{
  "calendar": {
    "weekends": true
  },
  "media": {
    "playerStyle": "material"
  },
  "weather": {
    "widgets": {
      "conditions": {
        "_order": 10,
        "city": false,
        "col": 0,
        "h": 2,
        "row": 2,
        "tone": "primary",
        "w": 2
      },
      "daily ": {
        "_order": 50,
        "col": 0,
        "forecast": "chart",
        "h": 2,
        "row": 0,
        "w": 4
      },
      "hourly": {
        "_order": 20,
        "col": 2,
        "forecast": "chart",
        "h": 2,
        "row": 2,
        "w": 2
      },
      "humidity": {
        "_order": 30,
        "col": 2,
        "graphics": true,
        "h": 2,
        "row": 4,
        "tone": "",
        "w": 1
      },
      "precipitation": {
        "_order": 60,
        "col": 1,
        "graphics": true,
        "h": 2,
        "row": 4,
        "tone": "",
        "w": 1
      },
      "uv": {
        "_order": 70,
        "col": 0,
        "graphics": true,
        "h": 2,
        "row": 4,
        "tone": "",
        "w": 1
      },
      "wind": {
        "_order": 40,
        "col": 3,
        "graphics": true,
        "h": 2,
        "row": 4,
        "tone": "",
        "w": 1
      }
    }
  }
}
```

Each `weather.widgets` entry may set `_order` (int, default 1000).


## `desktop.ojuny.dms.plugins`

- type: attrsOf (attrsOf plugin), default: {}
- description: DankMaterialShell plugins, keyed by plugin name.

### Plugin structure

```nix
desktop.ojuny.dms.plugins.<name> = {
  enable = false;  # bool
  src = <path or package>;  # required
  settings = {};  # attrs/TOML written to plugin_settings.json
  dir = "";  # string; plugins/ subdirectory name, empty means the attribute key
  config = {};  # attrs/TOML written to plugins/<dir>/config.json
};
```


## `desktop.ojuny.dankMenu`

- `desktop.ojuny.dankMenu.enable` (type: bool, default: false) — Whether to enable the dankMenu plugin with a Nix-managed menu.
- `desktop.ojuny.dankMenu.menu` (type: attrsOf, default: {}) — dankMenu tree keyed by dotted id (e.g. "learn.keybinds"). A non-empty tree overrides the plugin's bundled menu through the menuPath setting.
- `desktop.ojuny.dankMenu.settings` (type: either, default: {}) — Additional dankMenu plugin settings merged into plugin_settings.json.

### Menu row structure

```nix
desktop.ojuny.dankMenu.menu."<dotted-id>" = {
  icon = "apps";        # string (Material icon)
  label = "Apps";       # string
  aliases = [ "app" ];  # listOf string (optional)
  provider = "apps";    # null or string (optional)
  target = null;        # null or string (optional)
  action = null;        # null or string (optional)
  title = null;         # null or string (optional)
  iconFont = null;      # null or string (optional)
  when = null;          # null or string (shell condition, optional)
  checked = null;       # null or string (optional)
  disabled = null;      # null or string (optional)
};
```

When `menu` is non-empty and `enable` is true, modules write a generated menu JSON and set `menuPath` in `dankMenu` plugin settings.


## `desktop.ojuny.dms.clipboardSettings` — Full default structure

```nix
{
  "autoClearDays": 1,
  "clearAtStartup": true,
  "disableHistory": false,
  "disablePersist": false,
  "disabled": false,
  "maxEntrySize": 5242880,
  "maxHistory": 25
}
```


## Notes on completeness

- Mango global keys: all keys present in `lib/defaults/mango.nix` are exposed via `desktop.ojuny.mango.global` (flattened into TOML `[global]` by `lib/to-toml.nix`).
- Mango bind groups (`binds/mousebind/axisbind/gesturebind`): full default tree is in `lib/defaults/mango.nix`; structure is mode -> name -> bind fields as documented.
- Rules: `desktop.ojuny.mango.rules` is a TOML-typed set; defaults include `tag_rule` and `window_rule` entries as shown.
- DMS settings: full defaults included above. Collection keys (`barConfigs`, `dockConfigs`, `controlCenterWidgets`, `dashCards`, `dashTabs`, `dashOptions`) are id-keyed attrsets rendered to arrays by `lib/mk-config.nix` (ordered by `_order`); the remaining keys live in `desktop.ojuny.dms.settings`. Clipboard defaults included above (`clsettings.json`).
- DMS plugins: attrs keyed by plugin name with `enable`, `src` (path/package), `settings` (merged into `plugin_settings.json`), `dir` (plugins/ subdirectory name) and `config` (extra file at `plugins/<dir>/config.json`, e.g. the `nixMonitor` command set).
- dankMenu: structured menu rows + extra settings; when menu non-empty, `menuPath` is set automatically.

