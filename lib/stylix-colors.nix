{ lib }:
let
  stripHash = value:
    if builtins.substring 0 1 value == "#"
    then builtins.substring 1 (builtins.stringLength value - 1)
    else value;

  bases = colors:
    builtins.mapAttrs (_: stripHash) {
      inherit (colors)
        base00 base01 base02 base03 base04 base05 base06 base07
        base08 base09 base0A base0B base0C base0D base0E base0F;
    };

  rgba = colors: name: alpha: "0x" + (bases colors).${name} + alpha;

  dankThemeNamed =
    name: colors:
    let
      theme = {
        inherit name;
        primary = colors.withHashtag.base0D;
        primaryText = colors.withHashtag.base00;
        primaryContainer = colors.withHashtag.base0C;
        secondary = colors.withHashtag.base0E;
        surface = colors.withHashtag.base01;
        surfaceText = colors.withHashtag.base05;
        surfaceVariant = colors.withHashtag.base02;
        surfaceVariantText = colors.withHashtag.base04;
        surfaceTint = colors.withHashtag.base0D;
        background = colors.withHashtag.base00;
        backgroundText = colors.withHashtag.base05;
        outline = colors.withHashtag.base03;
        surfaceContainer = colors.withHashtag.base01;
        surfaceContainerHigh = colors.withHashtag.base02;
        surfaceContainerHighest = colors.withHashtag.base03;
        error = colors.withHashtag.base08;
        warning = colors.withHashtag.base0A;
        info = colors.withHashtag.base0C;
      };
    in
    {
      dark = theme;
      light = theme;
    };

  everforestBase16 = {
    base00 = "272e33";
    base01 = "2e383c";
    base02 = "414b50";
    base03 = "859289";
    base04 = "9da9a0";
    base05 = "d3c6aa";
    base06 = "e4e1cd";
    base07 = "fdf6e3";
    base08 = "7fbbb3";
    base09 = "d699b6";
    base0A = "dbbc7f";
    base0B = "83c092";
    base0C = "e69875";
    base0D = "a7c080";
    base0E = "e67e80";
    base0F = "4c3743";
  };

  everforestDarkHard = everforestBase16 // {
    withHashtag = builtins.mapAttrs (_: value: "#${value}") everforestBase16;
  };
in
{
  inherit everforestDarkHard;
  dankTheme = dankThemeNamed "Stylix";
  fallbackTheme = dankThemeNamed "Everforest Dark Hard" everforestDarkHard;

  mangoColors = colors: {
    root_color = "0x323232ff";
    border_color = rgba colors "base02" "ff";
    drop_color = rgba colors "base02" "55";
    split_color = rgba colors "base05" "ff";
    focus_color = rgba colors "base0D" "ff";
    urgent_color = rgba colors "base08" "ff";
    maximized_screen_color = rgba colors "base0E" "ff";
    scratchpad_color = rgba colors "base0A" "ff";
    global_color = rgba colors "base08" "ff";
    overlay_color = rgba colors "base0F" "ff";
    jump_label_decorate_fg_color = rgba colors "base05" "ff";
    jump_label_decorate_bg_color = rgba colors "base00" "ff";
    jump_label_decorate_focus_fg_color = rgba colors "base06" "ff";
    jump_label_decorate_focus_bg_color = rgba colors "base02" "ff";
    jump_label_decorate_border_color = rgba colors "base0D" "ff";
    group_bar_decorate_fg_color = rgba colors "base05" "ff";
    group_bar_decorate_bg_color = rgba colors "base01" "ff";
    group_bar_decorate_focus_fg_color = rgba colors "base06" "ff";
    group_bar_decorate_focus_bg_color = rgba colors "base02" "ff";
    group_bar_decorate_border_color = rgba colors "base0D" "ff";
    tab_bar_decorate_fg_color = rgba colors "base05" "ff";
    tab_bar_decorate_bg_color = rgba colors "base01" "ff";
    tab_bar_decorate_focus_fg_color = rgba colors "base06" "ff";
    tab_bar_decorate_focus_bg_color = rgba colors "base02" "ff";
    tab_bar_decorate_border_color = rgba colors "base0D" "ff";
    title_message_bar_decorate_fg_color = rgba colors "base05" "ff";
    title_message_bar_decorate_bg_color = rgba colors "base01" "ff";
    title_message_bar_decorate_focus_fg_color = rgba colors "base06" "ff";
    title_message_bar_decorate_focus_bg_color = rgba colors "base02" "ff";
    title_message_bar_decorate_border_color = rgba colors "base0D" "ff";
    dim_focused_color = rgba colors "base00" "aa";
    dim_unfocused_color = rgba colors "base00" "dd";
    group_bar_button_color = rgba colors "base0D" "ff";
    shadows_color = rgba colors "base00" "80";
  };
}
