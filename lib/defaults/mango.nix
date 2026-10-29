let
  pasteScript = builtins.path { name = "paste.sh"; path = ../scripts/paste.sh; };
  layoutbuttonScript = builtins.path { name = "layoutbutton.sh"; path = ../scripts/layoutbutton.sh; };
in
{
  global = {
    # input / keyboard
    repeat_rate = 25;
    repeat_delay = 600;
    numlock_on = 1;
    xkb_rules_layout = "us";

    # mouse
    mouse_natural_scrolling = 0;
    mouse_accel_profile = 1;
    mouse_accel_speed = 0.0;
    mouse_left_handed = 0;
    button_map = 1;

    # trackpad
    disable_trackpad = 0;
    tap_to_click = 1;
    tap_and_drag = 1;
    drag_lock = 1;
    swipe_min_threshold = 1;
    trackpad_natural_scrolling = 1;
    trackpad_accel_profile = 2;
    trackpad_accel_speed = 0.0;
    trackpad_scroll_method = 1;
    trackpad_click_method = 1;
    trackpad_disable_while_typing = 1;
    trackpad_left_handed = 0;
    trackpad_middle_button_emulation = 0;
    trackpad_scroll_factor = 1.0;

    # touch
    touch_enable = 1;
    touch_enable_mouse_emulation = 1;

    # focus / input
    allow_lock_transparent = 1;
    focus_on_activate = 0;
    sloppy_focus = 1;
    warp_cursor = 1;
    cursor_hide_timeout = 30;
    cursor_hide_on_keypress = 0;
    drag_tile_to_tile = 1;
    drag_tile_small = 1;
    drag_corner = 0;
    drag_warp_cursor = 1;
    axis_bind_apply_timeout = 100;

    # monitors / tags
    focus_cross_monitor = 1;
    exchange_cross_monitor = 1;
    view_current_to_back = 1;
    scratchpad_cross_monitor = 1;
    single_scratchpad = 0;
    tag_num = 10;
    tag_gather = 1;

    # window behaviour
    enable_floating_snap = 1;
    snap_distance = 30;
    no_border_when_single = 0;
    no_radius_when_single = 0;
    smart_gaps = 0;
    focused_opacity = 1.0;
    unfocused_opacity = 1.0;

    # appearance
    blur = 1;
    blur_layer = 0;
    blur_optimized = 0;
    blur_params_radius = 4;
    blur_params_num_passes = 2;
    blur_params_noise = 0.02;
    blur_params_brightness = 0.8;
    blur_params_contrast = 0.9;
    blur_params_saturation = 1.1;
    shadows = 0;
    border_radius = 12;
    border_px = 3;

    # decoration
    jump_label_decorate_border_width = 2;
    jump_label_decorate_corner_radius = 5;
    jump_label_decorate_padding_x = 10;
    jump_label_decorate_padding_y = 10;
    jump_label_decorate_font_desc = "CaskaydiaMono Nerd Font Mono 16";

    group_bar_height = 30;
    group_bar_decorate_border_width = 2;
    group_bar_decorate_corner_radius = 10;
    group_bar_decorate_padding_x = 0;
    group_bar_decorate_padding_y = 0;
    group_bar_decorate_font_desc = "CaskaydiaMono Nerd Font Mono 14";

    tab_bar_height = 30;
    tab_bar_decorate_border_width = 2;
    tab_bar_decorate_corner_radius = 10;
    tab_bar_decorate_padding_x = 0;
    tab_bar_decorate_padding_y = 0;
    tab_bar_decorate_font_desc = "CaskaydiaMono Nerd Font Mono 14";

    # gaps
    gap_inner_horizontal = 4;
    gap_inner_vertical = 4;
    gap_outer_horizontal = 4;
    gap_outer_vertical = 4;

    # animations
    animations = 1;
    animation_type_open = "zoom";
    animation_type_close = "zoom";
    animation_fade_in = 1;
    animation_fade_out = 1;
    layer_animations = 0;
    layer_animation_type_open = "zoom";
    layer_animation_type_close = "zoom";
    fade_in_begin_opacity = 0.5;
    fade_out_begin_opacity = 0.5;
    zoom_initial_ratio = 0.4;
    zoom_end_ratio = 0.9;
    animation_duration_move = 500;
    animation_duration_open = 400;
    animation_duration_tag = 300;
    animation_duration_close = 300;
    animation_duration_focus = 200;
    tag_animation_direction = 0;

    # layout: master
    new_is_master = 1;
    default_master_factor = 0.65;
    default_master_count = 1;
    center_master_overspread = 1;
    center_when_single_stack = 1;

    # layout: scroller
    scroller_structs = 20;
    scroller_default_proportion = 0.8;
    scroller_focus_center = 0;
    scroller_prefer_center = 0;
    scroller_prefer_overspread = 1;
    scroller_ignore_proportion_single = 1;
    scroller_default_proportion_single = 1;
    scroller_proportion_preset = [ 0.4 0.5 0.8 1.0 ];
    edge_scroller_pointer_focus = 1;
    edge_scroller_focus_allow_speed = 0.5;

    # layout: dwindle
    dwindle_split_ratio = 0.5;
    dwindle_smart_split = 0;
    dwindle_horizontal_split = 1;
    dwindle_vertical_split = 1;
    dwindle_preserve_split = 1;
    dwindle_smart_resize = 0;
    dwindle_drop_simple_split = 0;
    dwindle_manual_split = 0;

    # layout: monocle and deck
    monocle_tab_mode = 1;
    monocle_no_border = 0;
    monocle_no_gap = 0;
    monocle_no_radius = 0;
    monocle_right_button_close = 0;
    deck_tab_mode = 1;

    # title messages
    title_message_bar_height = 52;
    title_message_bar_gap = 20;
    title_message_bar_decorate_border_width = 0;
    title_message_bar_decorate_corner_radius = 15;
    title_message_bar_decorate_padding_x = 0;
    title_message_bar_decorate_padding_y = 0;
    title_message_bar_decorate_font_desc = "monospace Bold 13";

    # system behaviour
    allow_shortcuts_inhibit = 1;
    auto_reload_config = 1;
    disable_middle_paste = 0;
    sync_obj_enable = 1;
    xwayland_persistence = 1;

    # special tag
    special_dim = 0.5;
    special_gap_inner_horizontal = 5;
    special_gap_inner_vertical = 5;
    special_gap_outer_horizontal = 30;
    special_gap_outer_vertical = 30;

    # overview
    hotarea_size = 0;
    enable_hotarea = 0;
  };

  env = {
    XDG_SESSION_DESKTOP = "wlroots";
    XDG_CURRENT_DESKTOP = "wlroots";
    QT_QPA_PLATFORM = "wayland;xcb";
    MOZ_ENABLE_WAYLAND = "1";
    OZONE_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  var = { };

  execOnce = [
    "dms run"
    "wl-clip-persist --clipboard both"
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
    "ojuny-ghostty"
    "ydotoold"
  ];

  exec = [ ];

  rules = {
    window_rule = [
      { app_id = "foot"; focused_opacity = 0.7; unfocused_opacity = 0.7; }
      { title = "Floating-Menu"; is_floating = 1; height = 0.6; width = 0.6; }
    ];
    tag_rule = [
      { id = 0; layout_name = "dwindle"; }
    ];
    layer_rule = [ ];
    monitor_rule = [ ];
    device_rule = [ ];
  };

  binds = {
    common = {
      # System / Common
      reload = {
        modifier = [ "SUPER" ];
        keys = [ "R" ];
        dispatcher = "reload_config";
        args = [ ];
        description = "Reload configuration";
        group = "System";
        subcat = "Common";
      };
      keybinds = {
        modifier = [ "SUPER" ];
        keys = [ "K" ];
        dispatcher = "spawn";
        args = "dms ipc call keybinds open binds";
        description = "Show Keybinds";
        group = "System";
        subcat = "Common";
      };
      quit = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "Escape" ];
        dispatcher = "quit";
        args = [ ];
        description = "Quit Mango";
        group = "System";
        subcat = "Common";
      };
      overview = {
        modifier = [ "ALT" ];
        keys = [ "Tab" ];
        dispatcher = "overcircle";
        args = "next";
        description = "Toggle/cycle overview";
        group = "System";
        subcat = "Common";
      };

      # System / Screenshots
      screenshot = {
        modifier = [ ];
        keys = [ "PRINT" ];
        dispatcher = "spawn";
        args = "dms screenshot";
        description = "Selection screenshot";
        group = "System";
        subcat = "Screenshots";
      };
      screenshotWindow = {
        modifier = [ "SUPER" ];
        keys = [ "PRINT" ];
        dispatcher = "spawn";
        args = "dms screenshot window";
        description = "Focused window screenshot";
        group = "System";
        subcat = "Screenshots";
      };
      screenshotFull = {
        modifier = [ "ALT" ];
        keys = [ "PRINT" ];
        dispatcher = "spawn";
        args = "dms screenshot full";
        description = "Fullscreen screenshot";
        group = "System";
        subcat = "Screenshots";
      };

      # System / Groups
      groupleave = {
        modifier = [ "SUPER" ];
        keys = [ "Z" ];
        dispatcher = "groupleave";
        args = [ ];
        description = "Leave group";
        group = "System";
        subcat = "Groups";
      };

      # Applications / Launch
      terminal = {
        modifier = [ "SUPER" ];
        keys = [ "Return" ];
        dispatcher = "spawn";
        args = "ojuny-ghostty";
        description = "Open terminal";
        group = "Applications";
        subcat = "Launch";
      };
      terminalAlt = {
        modifier = [ "SUPER" ];
        keys = [ "Tab" ];
        dispatcher = "spawn";
        args = "ojuny-ghostty";
        description = "Open terminal";
        group = "Applications";
        subcat = "Launch";
      };
      browser = {
        modifier = [ "SUPER" ];
        keys = [ "B" ];
        dispatcher = "spawn";
        args = "firefox --new-window";
        description = "Open browser";
        group = "Applications";
        subcat = "Launch";
      };
      files = {
        modifier = [ "SUPER" ];
        keys = [ "E" ];
        dispatcher = "spawn";
        args = "dfiles open";
        description = "Open files";
        group = "Applications";
        subcat = "Launch";
      };
      launcher = {
        modifier = [ "SUPER" ];
        keys = [ "SPACE" ];
        dispatcher = "spawn";
        args = "dms ipc call spotlight toggle";
        description = "Toggle launcher";
        group = "Applications";
        subcat = "Launch";
      };
      settings = {
        modifier = [ "SUPER" ];
        keys = [ "X" ];
        dispatcher = "spawn";
        args = "dms ipc call dankMenu toggle root";
        description = "Toggle Menu";
        group = "Applications";
        subcat = "Launch";
      };
      settingsAlt = {
        modifier = [ "SUPER" ];
        keys = [ "Escape" ];
        dispatcher = "spawn";
        args = "dms ipc call dankMenu toggle root";
        description = "Toggle Menu";
        group = "Applications";
        subcat = "Launch";
      };
      # Windows / Management
      close = {
        modifier = [ "SUPER" ];
        keys = [ "Q" ];
        dispatcher = "killclient";
        args = [ ];
        description = "Kill client";
        group = "Windows";
        subcat = "Management";
      };
      maximize = {
        modifier = [ "SUPER" ];
        keys = [ "F" ];
        dispatcher = "togglemaximizescreen";
        args = [ ];
        description = "Toggle maximize";
        group = "Windows";
        subcat = "Management";
      };
      fullscreen = {
        modifier = [ "SUPER" ];
        keys = [ "F11" ];
        dispatcher = "togglefullscreen";
        args = [ ];
        description = "Toggle fullscreen";
        group = "Windows";
        subcat = "Management";
      };
      paste = {
        modifier = [ "SUPER" ];
        keys = [ "V" ];
        dispatcher = "spawn_shell";
        args = pasteScript;
        description = "Paste clipboard";
        group = "Windows";
        subcat = "Management";
      };

      # Windows / Layout
      layoutbutton = {
        modifier = [ "SUPER" ];
        keys = [ "H" ];
        dispatcher = "spawn_shell";
        args = layoutbuttonScript;
        description = "Layout-Specific Toggle";
        group = "Windows";
        subcat = "Layout";
      };

      # Windows / Special Workspace
      specialTagWindow = {
        modifier = [ "SUPER" ];
        keys = [ "T" ];
        dispatcher = "tag_special_tag";
        args = [ ];
        description = "Move window into or out of special workspace";
        group = "Windows";
        subcat = "Special Workspace";
      };
      specialTagToggle = {
        modifier = [ "SUPER" "ALT" ];
        keys = [ "SPACE" ];
        dispatcher = "toggle_special_tag";
        args = [ ];
        description = "Toggle Special Workspace";
        group = "Windows";
        subcat = "Special Workspace";
      };

      # Navigation
      viewLeft = {
        modifier = [ "SUPER" ];
        keys = [ "Left" ];
        dispatcher = "viewtoleft";
        args = [ "0" ];
        description = "Previous Workspace";
        group = "Navigation";
        subcat = "";
      };
      viewRight = {
        modifier = [ "SUPER" ];
        keys = [ "Right" ];
        dispatcher = "viewtoright";
        args = [ "0" ];
        description = "Next Workspace";
        group = "Navigation";
        subcat = "";
      };
      viewUp = {
        modifier = [ "SUPER" ];
        keys = [ "Up" ];
        dispatcher = "viewtoleft";
        args = [ "0" ];
        description = "Previous Workspace";
        group = "Navigation";
        subcat = "";
      };
      viewDown = {
        modifier = [ "SUPER" ];
        keys = [ "Down" ];
        dispatcher = "viewtoright";
        args = [ "0" ];
        description = "Next Workspace";
        group = "Navigation";
        subcat = "";
      };

      # Alt Modes / Common
      keymodeDefault = {
        modifier = [ "SUPER" ];
        keys = [ "BackSpace" ];
        dispatcher = "setkeymode";
        args = "default";
        description = "Enter default mode";
        group = "Alt Modes";
        subcat = "Common";
      };
      keymodeMovement = {
        modifier = [ "SUPER" ];
        keys = [ "F1" ];
        dispatcher = "setkeymode";
        args = "movement";
        description = "Enter movement mode";
        group = "Alt Modes";
        subcat = "Common";
      };
      keymodeGroups = {
        modifier = [ "SUPER" ];
        keys = [ "F2" ];
        dispatcher = "setkeymode";
        args = "groups";
        description = "Enter groups mode";
        group = "Alt Modes";
        subcat = "Common";
      };
      keymodeResize = {
        modifier = [ "SUPER" ];
        keys = [ "F3" ];
        dispatcher = "setkeymode";
        args = "resize";
        description = "Enter resize mode";
        group = "Alt Modes";
        subcat = "Common";
      };
    };

    default = {
      focusUp = {
        modifier = [ "SUPER" ];
        keys = [ "W" ];
        dispatcher = "focusdir";
        args = "up";
        description = "Focus window in direction";
        group = "Navigation";
        subcat = "";
      };
      focusLeft = {
        modifier = [ "SUPER" ];
        keys = [ "A" ];
        dispatcher = "focusdir";
        args = "left";
        description = "Focus window in direction";
        group = "Navigation";
        subcat = "";
      };
      focusDown = {
        modifier = [ "SUPER" ];
        keys = [ "S" ];
        dispatcher = "focusdir";
        args = "down";
        description = "Focus window in direction";
        group = "Navigation";
        subcat = "";
      };
      focusRight = {
        modifier = [ "SUPER" ];
        keys = [ "D" ];
        dispatcher = "focusdir";
        args = "right";
        description = "Focus window in direction";
        group = "Navigation";
        subcat = "";
      };
      moveUp = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "W" ];
        dispatcher = "move_client";
        args = "up";
        description = "Move window in direction";
        group = "Navigation";
        subcat = "";
      };
      moveLeft = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "A" ];
        dispatcher = "move_client";
        args = "left";
        description = "Move window in direction";
        group = "Navigation";
        subcat = "";
      };
      moveDown = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "S" ];
        dispatcher = "move_client";
        args = "down";
        description = "Move window in direction";
        group = "Navigation";
        subcat = "";
      };
      moveRight = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "D" ];
        dispatcher = "move_client";
        args = "right";
        description = "Move window in direction";
        group = "Navigation";
        subcat = "";
      };
      workspace1 = { modifier = [ "SUPER" ]; keys = [ "1" ]; dispatcher = "comboview"; args = [ "1" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      workspace2 = { modifier = [ "SUPER" ]; keys = [ "2" ]; dispatcher = "comboview"; args = [ "2" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      workspace3 = { modifier = [ "SUPER" ]; keys = [ "3" ]; dispatcher = "comboview"; args = [ "3" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      workspace4 = { modifier = [ "SUPER" ]; keys = [ "4" ]; dispatcher = "comboview"; args = [ "4" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      workspace5 = { modifier = [ "SUPER" ]; keys = [ "5" ]; dispatcher = "comboview"; args = [ "5" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      workspace6 = { modifier = [ "SUPER" ]; keys = [ "6" ]; dispatcher = "comboview"; args = [ "6" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      workspace7 = { modifier = [ "SUPER" ]; keys = [ "7" ]; dispatcher = "comboview"; args = [ "7" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      workspace8 = { modifier = [ "SUPER" ]; keys = [ "8" ]; dispatcher = "comboview"; args = [ "8" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      workspace9 = { modifier = [ "SUPER" ]; keys = [ "9" ]; dispatcher = "comboview"; args = [ "9" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      workspace10 = { modifier = [ "SUPER" ]; keys = [ "0" ]; dispatcher = "comboview"; args = [ "10" ]; description = "Switch to workspace, hold for multi-tag"; group = "Navigation"; subcat = ""; };
      tagsilent1 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "1" ]; dispatcher = "tagsilent"; args = [ "1" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
      tagsilent2 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "2" ]; dispatcher = "tagsilent"; args = [ "2" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
      tagsilent3 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "3" ]; dispatcher = "tagsilent"; args = [ "3" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
      tagsilent4 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "4" ]; dispatcher = "tagsilent"; args = [ "4" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
      tagsilent5 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "5" ]; dispatcher = "tagsilent"; args = [ "5" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
      tagsilent6 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "6" ]; dispatcher = "tagsilent"; args = [ "6" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
      tagsilent7 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "7" ]; dispatcher = "tagsilent"; args = [ "7" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
      tagsilent8 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "8" ]; dispatcher = "tagsilent"; args = [ "8" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
      tagsilent9 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "9" ]; dispatcher = "tagsilent"; args = [ "9" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
      tagsilent10 = { modifier = [ "SUPER" "SHIFT" ]; keys = [ "0" ]; dispatcher = "tagsilent"; args = [ "10" ]; description = "Move window to workspace"; group = "Navigation"; subcat = ""; };
    };

    movement = {
      exchangeUp = { modifier = [ "none" ]; keys = [ "W" ]; dispatcher = "exchange_client"; args = "up"; description = "Move window"; group = "Alt Modes"; subcat = "Movement Mode"; };
      exchangeLeft = { modifier = [ "none" ]; keys = [ "A" ]; dispatcher = "exchange_client"; args = "left"; description = "Move window"; group = "Alt Modes"; subcat = "Movement Mode"; };
      exchangeDown = { modifier = [ "none" ]; keys = [ "S" ]; dispatcher = "exchange_client"; args = "down"; description = "Move window"; group = "Alt Modes"; subcat = "Movement Mode"; };
      exchangeRight = { modifier = [ "none" ]; keys = [ "D" ]; dispatcher = "exchange_client"; args = "right"; description = "Move window"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent1 = { modifier = [ "none" ]; keys = [ "1" ]; dispatcher = "tagsilent"; args = [ "1" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent2 = { modifier = [ "none" ]; keys = [ "2" ]; dispatcher = "tagsilent"; args = [ "2" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent3 = { modifier = [ "none" ]; keys = [ "3" ]; dispatcher = "tagsilent"; args = [ "3" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent4 = { modifier = [ "none" ]; keys = [ "4" ]; dispatcher = "tagsilent"; args = [ "4" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent5 = { modifier = [ "none" ]; keys = [ "5" ]; dispatcher = "tagsilent"; args = [ "5" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent6 = { modifier = [ "none" ]; keys = [ "6" ]; dispatcher = "tagsilent"; args = [ "6" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent7 = { modifier = [ "none" ]; keys = [ "7" ]; dispatcher = "tagsilent"; args = [ "7" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent8 = { modifier = [ "none" ]; keys = [ "8" ]; dispatcher = "tagsilent"; args = [ "8" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent9 = { modifier = [ "none" ]; keys = [ "9" ]; dispatcher = "tagsilent"; args = [ "9" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
      tagsilent10 = { modifier = [ "none" ]; keys = [ "0" ]; dispatcher = "tagsilent"; args = [ "10" ]; description = "Send window to workspace"; group = "Alt Modes"; subcat = "Movement Mode"; };
    };

    groups = {
      toggleview1 = { modifier = [ "none" ]; keys = [ "1" ]; dispatcher = "toggleview"; args = [ "1" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
      toggleview2 = { modifier = [ "none" ]; keys = [ "2" ]; dispatcher = "toggleview"; args = [ "2" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
      toggleview3 = { modifier = [ "none" ]; keys = [ "3" ]; dispatcher = "toggleview"; args = [ "3" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
      toggleview4 = { modifier = [ "none" ]; keys = [ "4" ]; dispatcher = "toggleview"; args = [ "4" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
      toggleview5 = { modifier = [ "none" ]; keys = [ "5" ]; dispatcher = "toggleview"; args = [ "5" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
      toggleview6 = { modifier = [ "none" ]; keys = [ "6" ]; dispatcher = "toggleview"; args = [ "6" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
      toggleview7 = { modifier = [ "none" ]; keys = [ "7" ]; dispatcher = "toggleview"; args = [ "7" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
      toggleview8 = { modifier = [ "none" ]; keys = [ "8" ]; dispatcher = "toggleview"; args = [ "8" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
      toggleview9 = { modifier = [ "none" ]; keys = [ "9" ]; dispatcher = "toggleview"; args = [ "9" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
      toggleview10 = { modifier = [ "none" ]; keys = [ "0" ]; dispatcher = "toggleview"; args = [ "10" ]; description = "Toggle workspace visibility"; group = "Alt Modes"; subcat = "Groups Mode"; };
    };

    resize = {
      smartresizeUp = { modifier = [ "none" ]; keys = [ "W" ]; dispatcher = "smartresizewin"; args = "up"; description = "Resize window"; group = "Alt Modes"; subcat = "Resize Mode"; };
      smartresizeLeft = { modifier = [ "none" ]; keys = [ "A" ]; dispatcher = "smartresizewin"; args = "left"; description = "Resize window"; group = "Alt Modes"; subcat = "Resize Mode"; };
      smartresizeDown = { modifier = [ "none" ]; keys = [ "S" ]; dispatcher = "smartresizewin"; args = "down"; description = "Resize window"; group = "Alt Modes"; subcat = "Resize Mode"; };
      smartresizeRight = { modifier = [ "none" ]; keys = [ "D" ]; dispatcher = "smartresizewin"; args = "right"; description = "Resize window"; group = "Alt Modes"; subcat = "Resize Mode"; };
    };
  };

  mousebind = {
    default = {
      move = {
        modifier = [ "SUPER" ];
        keys = [ "btn_left" ];
        dispatcher = "moveresize";
        args = "curmove";
        description = "Move window";
        group = "Mouse";
        subcat = "";
      };
      maximize = {
        modifier = [ ];
        keys = [ "btn_middle" ];
        dispatcher = "togglemaximizescreen";
        args = "0";
        description = "Maximize window";
        group = "Mouse";
        subcat = "";
      };
      resize = {
        modifier = [ "SUPER" ];
        keys = [ "btn_right" ];
        dispatcher = "moveresize";
        args = "curresize";
        description = "Resize window";
        group = "Mouse";
        subcat = "";
      };
    };
  };

  axisbind = {
    default = {
      viewPrev = {
        modifier = [ "SUPER" ];
        keys = [ "UP" ];
        dispatcher = "viewtoleft_have_client";
        args = [ ];
        description = "Scroll views left";
        group = "Mouse";
        subcat = "Scroll";
      };
      viewNext = {
        modifier = [ "SUPER" ];
        keys = [ "DOWN" ];
        dispatcher = "viewtoright_have_client";
        args = [ ];
        description = "Scroll views right";
        group = "Mouse";
        subcat = "Scroll";
      };
    };
  };

  gesturebind = { };
}
