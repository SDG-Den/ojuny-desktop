{ pkgs }:
pkgs.writeShellApplication {
  name = "ojuny-WinMenu";
  runtimeInputs = [
    pkgs.coreutils
    pkgs.systemd
  ];
  text = builtins.readFile ./ojuny-WinMenu.sh;
}
