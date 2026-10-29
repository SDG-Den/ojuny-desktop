#!/usr/bin/env bash
set -u

TMP="/tmp/ojuny-winmenu.$$"
mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Quick Links" "$1"
  else
    printf '%s\n' "$1" >&2
  fi
}

require() {
  command -v "$1" >/dev/null 2>&1
}

open_settings() {
  if require nix-settings-gui; then
    nix-settings-gui >/dev/null 2>&1 &
  else
    notify "nix-settings-gui is not installed"
  fi
}

hold_terminal() {
  ghostty -e sh -c "$1; printf '\\nPress Enter to close'; read -r _" >/dev/null 2>&1 &
}

do_power() {
  case "$1" in
    shutdown) systemctl poweroff ;;
    restart) systemctl reboot ;;
    sleep) systemctl suspend ;;
    signout) loginctl terminate-session "${XDG_SESSION_ID:-}" 2>/dev/null || loginctl terminate-user "$USER" ;;
    *) return 0 ;;
  esac
}

show_power() {
  {
    printf 'Shut down\0display\x1f[U]  Shut down\x1fmeta\x1fU\x1finfo\x1fshutdown\n'
    printf 'Restart\0display\x1f[R]  Restart\x1fmeta\x1fR\x1finfo\x1frestart\n'
    printf 'Sleep\0display\x1f[S]  Sleep\x1fmeta\x1fS\x1finfo\x1fsleep\n'
    printf 'Sign out\0display\x1f[I]  Sign out\x1fmeta\x1fI\x1finfo\x1fsignout\n'
  } > "$TMP/power-items"

  sleep 0.2
  dms dmenu --input "$TMP/power-items" -p "Shut down or sign out" --icon power_settings_new \
    --no-custom --disable-history --print-info --select "Shut down" \
    --keybind 1=u --keybind 2=r --keybind 3=s --keybind 4=i > "$TMP/power-pick"
  local rc=$?

  case "$rc" in
    0)
      mapfile -t picked < "$TMP/power-pick"
      POWER="${picked[1]:-}"
      return 0
      ;;
    10) POWER="shutdown"; return 0 ;;
    11) POWER="restart"; return 0 ;;
    12) POWER="sleep"; return 0 ;;
    13) POWER="signout"; return 0 ;;
    *) return 1 ;;
  esac
}

run_prompt() {
  dms dmenu --prompt-only -p "Run" --disable-history > "$TMP/run"
  local rc=$?
  [ "$rc" = 0 ] || return 0
  local cmd
  IFS= read -r cmd < "$TMP/run" || true
  [ -n "${cmd:-}" ] || return 0
  nohup sh -c "$cmd" >/dev/null 2>&1 &
}

dispatch() {
  case "$1" in
    installed-apps)
      if require nix-shell-gui; then
        nix-shell-gui >/dev/null 2>&1 &
      else
        open_settings
      fi
      ;;
    settings) open_settings ;;
    system) hold_terminal "fastfetch" ;;
    event-viewer) hold_terminal "journalctl -b -p warning --no-pager" ;;
    device-manager) hold_terminal "lspci -nnk; printf '\\n'; lsusb" ;;
    network)
      if require nm-connection-editor; then
        nm-connection-editor >/dev/null 2>&1 &
      else
        open_settings
      fi
      ;;
    computer-management) open_settings ;;
    power-options) open_settings ;;
    terminal) ghostty >/dev/null 2>&1 & ;;
    terminal-admin) ghostty -e sudo -i >/dev/null 2>&1 & ;;
    task-manager) ghostty -e dgop >/dev/null 2>&1 & ;;
    files)
      if require dfiles; then
        dfiles open >/dev/null 2>&1 &
      else
        notify "dux-files is not installed"
      fi
      ;;
    search) dms ipc call spotlight toggle ;;
    run) run_prompt ;;
    *) return 0 ;;
  esac
}

show_main() {
  {
    printf 'Installed apps\0display\x1f[I]  Installed apps\x1fmeta\x1fI\x1finfo\x1finstalled-apps\n'
    printf 'Settings\0display\x1f[S]  Settings\x1fmeta\x1fS\x1finfo\x1fsettings\n'
    printf 'System\0display\x1f[Y]  System\x1fmeta\x1fY\x1finfo\x1fsystem\n'
    printf 'Event Viewer\0display\x1f[V]  Event Viewer\x1fmeta\x1fV\x1finfo\x1fevent-viewer\n'
    printf 'Device Manager\0display\x1f[D]  Device Manager\x1fmeta\x1fD\x1finfo\x1fdevice-manager\n'
    printf 'Network connections\0display\x1f[N]  Network connections\x1fmeta\x1fN\x1finfo\x1fnetwork\n'
    printf 'Computer Management\0display\x1f[G]  Computer Management\x1fmeta\x1fG\x1finfo\x1fcomputer-management\n'
    printf 'Power options\0display\x1f[P]  Power options\x1fmeta\x1fP\x1finfo\x1fpower-options\n'
    printf 'Terminal\0display\x1f[C]  Terminal\x1fmeta\x1fC\x1finfo\x1fterminal\n'
    printf 'Terminal (Admin)\0display\x1f[A]  Terminal (Admin)\x1fmeta\x1fA\x1finfo\x1fterminal-admin\n'
    printf 'Task Manager\0display\x1f[T]  Task Manager\x1fmeta\x1fT\x1finfo\x1ftask-manager\n'
    printf 'File Explorer\0display\x1f[E]  File Explorer\x1fmeta\x1fE\x1finfo\x1ffiles\n'
    printf 'Search\0display\x1f[F]  Search\x1fmeta\x1fF\x1finfo\x1fsearch\n'
    printf 'Run\0display\x1f[R]  Run\x1fmeta\x1fR\x1finfo\x1frun\n'
    printf 'Shut down or sign out\0display\x1f[U]  Shut down or sign out\x1fmeta\x1fU\x1finfo\x1fshutdown-menu\n'
  } > "$TMP/items"

  dms dmenu --input "$TMP/items" -p "Quick Links" --icon menu \
    --no-custom --disable-history --print-info --size 4 --select "Installed apps" \
    --keybind 1=i --keybind 2=s --keybind 3=y --keybind 4=v --keybind 5=d \
    --keybind 6=n --keybind 7=g --keybind 8=p --keybind 9=c --keybind 10=a \
    --keybind 11=t --keybind 12=e --keybind 13=f --keybind 14=r --keybind 15=u \
    > "$TMP/pick"
  local rc=$?

  case "$rc" in
    0)
      mapfile -t picked < "$TMP/pick"
      ACTION="${picked[1]:-}"
      return 0
      ;;
    10) ACTION=installed-apps; return 0 ;;
    11) ACTION=settings; return 0 ;;
    12) ACTION=system; return 0 ;;
    13) ACTION=event-viewer; return 0 ;;
    14) ACTION=device-manager; return 0 ;;
    15) ACTION=network; return 0 ;;
    16) ACTION=computer-management; return 0 ;;
    17) ACTION=power-options; return 0 ;;
    18) ACTION=terminal; return 0 ;;
    19) ACTION=terminal-admin; return 0 ;;
    20) ACTION=task-manager; return 0 ;;
    21) ACTION=files; return 0 ;;
    22) ACTION=search; return 0 ;;
    23) ACTION=run; return 0 ;;
    24) ACTION=shutdown-menu; return 0 ;;
    *) return 1 ;;
  esac
}

if ! require dms; then
  notify "dms is not on PATH; start Quick Links from the desktop session."
  exit 1
fi

while :; do
  if ! show_main; then
    exit 0
  fi

  case "$ACTION" in
    shutdown-menu)
      if show_power; then
        do_power "$POWER"
        exit 0
      fi
      sleep 0.2
      ;;
    *)
      dispatch "$ACTION"
      exit 0
      ;;
  esac
done
