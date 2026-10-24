{
  lib,
  pkgs,
  colors,
}:
let
  hex = name: lib.removePrefix "#" colors.withHashtag.${name};

  palette = [
    "0=${hex "base00"}"
    "1=${hex "base08"}"
    "2=${hex "base0B"}"
    "3=${hex "base0A"}"
    "4=${hex "base0D"}"
    "5=${hex "base0E"}"
    "6=${hex "base0C"}"
    "7=${hex "base05"}"
    "8=${hex "base03"}"
    "9=${hex "base09"}"
    "10=${hex "base0B"}"
    "11=${hex "base0A"}"
    "12=${hex "base0D"}"
    "13=${hex "base0E"}"
    "14=${hex "base0C"}"
    "15=${hex "base07"}"
  ];

  keybinds = [
    "alt+up=new_split:up"
    "alt+down=new_split:down"
    "alt+left=new_split:left"
    "alt+right=new_split:right"
    "ctrl+alt+r=reload_config"
    "ctrl+shift+r=reset"
    "ctrl+shift+c=copy_to_clipboard"
    "ctrl+shift+v=paste_from_clipboard"
    "ctrl+a=select_all"
    "shift+left=adjust_selection:left"
    "shift+right=adjust_selection:right"
    "shift+up=adjust_selection:up"
    "shift+down=adjust_selection:down"
  ];

  lines = [
    "background = ${hex "base00"}"
    "foreground = ${hex "base05"}"
    "cursor-color = ${hex "base05"}"
    "cursor-text = ${hex "base00"}"
    "selection-background = ${hex "base02"}"
    "selection-foreground = ${hex "base05"}"
    "scrollback-limit = 1048576000"
    "background-opacity = 0.5"
    "link-url = true"
    "link-previews = true"
    "focus-follows-mouse = true"
    "window-inherit-working-directory = false"
    "tab-inherit-working-directory = true"
    "split-inherit-working-directory = true"
    "font-family = CaskaydiaCove Nerd Font Mono"
    "font-family = monospace"
    "window-decoration = none"
    "confirm-close-surface = false"
    "gtk-single-instance = false"
    "clipboard-read = allow"
    "clipboard-write = allow"
  ]
  ++ map (entry: "palette = ${entry}") palette
  ++ map (entry: "keybind = ${entry}") keybinds;
in
pkgs.writeText "ojuny-ghostty-config" (lib.concatStringsSep "\n" lines + "\n")
