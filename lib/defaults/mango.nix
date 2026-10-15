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
    default = {
      terminal = {
        modifier = [ "SUPER" ];
        keys = [ "Return" ];
        dispatcher = "spawn";
        args = "ghostty";
        description = "Terminal";
      };
      browser = {
        modifier = [ "SUPER" ];
        keys = [ "B" ];
        dispatcher = "spawn";
        args = "firefox --new-window";
        description = "Open Browser";
      };
      files = {
        modifier = [ "SUPER" ];
        keys = [ "E" ];
        dispatcher = "spawn";
        args = "nautilus --new-window";
        description = "Open Files";
      };
      launcher = {
        modifier = [ "SUPER" ];
        keys = [ "SPACE" ];
        dispatcher = "spawn";
        args = "dms ipc call spotlight toggle";
        description = "Launcher";
      };
      settings = {
        modifier = [ "SUPER" ];
        keys = [ "X" ];
        dispatcher = "spawn";
        args = "dms ipc call dankMenu toggle root";
        description = "Toggle Settings";
      };
      keybinds = {
        modifier = [ "SUPER" ];
        keys = [ "K" ];
        dispatcher = "spawn";
        args = "dms ipc call keybinds open binds";
        description = "Show Keybinds";
      };
      reload = {
        modifier = [ "SUPER" ];
        keys = [ "R" ];
        dispatcher = "reload_config";
        args = [ ];
        description = "Reload Config";
      };
      close = {
        modifier = [ "SUPER" ];
        keys = [ "Q" ];
        dispatcher = "killclient";
        args = [ ];
        description = "Kill Client";
      };
      quit = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "Escape" ];
        dispatcher = "quit";
        args = [ ];
        description = "Quit Mango";
      };
      maximize = {
        modifier = [ "SUPER" ];
        keys = [ "F" ];
        dispatcher = "togglemaximizescreen";
        args = [ ];
        description = "Toggle Maximize";
      };
      fullscreen = {
        modifier = [ "SUPER" ];
        keys = [ "F11" ];
        dispatcher = "togglefullscreen";
        args = [ ];
        description = "Toggle Fullscreen";
      };
      floating = {
        modifier = [ "SUPER" ];
        keys = [ "V" ];
        dispatcher = "togglefloating";
        args = [ ];
        description = "Toggle Floating";
      };
      focusLeft = {
        modifier = [ "SUPER" ];
        keys = [ "A" ];
        dispatcher = "focusdir";
        args = "left";
        description = "Focus Left";
      };
      focusDown = {
        modifier = [ "SUPER" ];
        keys = [ "S" ];
        dispatcher = "focusdir";
        args = "down";
        description = "Focus Down";
      };
      focusUp = {
        modifier = [ "SUPER" ];
        keys = [ "W" ];
        dispatcher = "focusdir";
        args = "up";
        description = "Focus Up";
      };
      focusRight = {
        modifier = [ "SUPER" ];
        keys = [ "D" ];
        dispatcher = "focusdir";
        args = "right";
        description = "Focus Right";
      };
      moveUp = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "W" ];
        dispatcher = "move_client";
        args = "up";
        description = "Move Client Up";
      };
      moveLeft = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "A" ];
        dispatcher = "move_client";
        args = "left";
        description = "Move Client Left";
      };
      moveDown = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "S" ];
        dispatcher = "move_client";
        args = "down";
        description = "Move Client Down";
      };
      moveRight = {
        modifier = [ "SUPER" "SHIFT" ];
        keys = [ "D" ];
        dispatcher = "move_client";
        args = "right";
        description = "Move Client Right";
      };
      viewLeft = {
        modifier = [ "SUPER" ];
        keys = [ "Left" ];
        dispatcher = "viewtoleft";
        args = [ "0" ];
        description = "Previous Tag";
      };
      viewRight = {
        modifier = [ "SUPER" ];
        keys = [ "Right" ];
        dispatcher = "viewtoright";
        args = [ "0" ];
        description = "Next Tag";
      };
      workspace1 = { modifier = [ "SUPER" ]; keys = [ "1" ]; dispatcher = "comboview"; args = [ "1" ]; description = "Workspace 1"; };
      workspace2 = { modifier = [ "SUPER" ]; keys = [ "2" ]; dispatcher = "comboview"; args = [ "2" ]; description = "Workspace 2"; };
      workspace3 = { modifier = [ "SUPER" ]; keys = [ "3" ]; dispatcher = "comboview"; args = [ "3" ]; description = "Workspace 3"; };
      workspace4 = { modifier = [ "SUPER" ]; keys = [ "4" ]; dispatcher = "comboview"; args = [ "4" ]; description = "Workspace 4"; };
      workspace5 = { modifier = [ "SUPER" ]; keys = [ "5" ]; dispatcher = "comboview"; args = [ "5" ]; description = "Workspace 5"; };
      workspace6 = { modifier = [ "SUPER" ]; keys = [ "6" ]; dispatcher = "comboview"; args = [ "6" ]; description = "Workspace 6"; };
      workspace7 = { modifier = [ "SUPER" ]; keys = [ "7" ]; dispatcher = "comboview"; args = [ "7" ]; description = "Workspace 7"; };
      workspace8 = { modifier = [ "SUPER" ]; keys = [ "8" ]; dispatcher = "comboview"; args = [ "8" ]; description = "Workspace 8"; };
      workspace9 = { modifier = [ "SUPER" ]; keys = [ "9" ]; dispatcher = "comboview"; args = [ "9" ]; description = "Workspace 9"; };
      workspace10 = { modifier = [ "SUPER" ]; keys = [ "0" ]; dispatcher = "comboview"; args = [ "10" ]; description = "Workspace 10"; };
      screenshot = {
        modifier = [ ];
        keys = [ "PRINT" ];
        dispatcher = "spawn";
        args = "dms screenshot";
        description = "Selection Screenshot";
      };
      screenshotWindow = {
        modifier = [ "SUPER" ];
        keys = [ "PRINT" ];
        dispatcher = "spawn";
        args = "dms screenshot window";
        description = "Window Screenshot";
      };
      screenshotFull = {
        modifier = [ "ALT" ];
        keys = [ "PRINT" ];
        dispatcher = "spawn";
        args = "dms screenshot full";
        description = "Full Screenshot";
      };
    };
  };

  mousebind = {
    default = {
      move = {
        modifier = [ "SUPER" ];
        keys = [ "btn_left" ];
        dispatcher = "moveresize";
        args = "curmove";
        description = "Move Window";
      };
      resize = {
        modifier = [ "SUPER" ];
        keys = [ "btn_right" ];
        dispatcher = "moveresize";
        args = "curresize";
        description = "Resize Window";
      };
      maximize = {
        modifier = [ ];
        keys = [ "btn_middle" ];
        dispatcher = "togglemaximizescreen";
        args = "0";
        description = "Toggle Maximize";
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
        description = "Previous Tag";
      };
      viewNext = {
        modifier = [ "SUPER" ];
        keys = [ "DOWN" ];
        dispatcher = "viewtoright_have_client";
        args = [ ];
        description = "Next Tag";
      };
    };
  };

  gesturebind = { };
}
