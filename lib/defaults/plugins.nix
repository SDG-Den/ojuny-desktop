{ lib, registry }:
let
  sources = lib.mapAttrs (_: src: {
    inherit src;
    enable = false;
    settings = { };
  }) registry;

  enabledDefaults = {
    dankMenu.enable = true;
    dankKDEConnect = {
      enable = true;
      settings.scanSubdirectories = true;
    };
    nixMonitor = {
      enable = true;
      dir = "NixMonitor";
      settings = {
        showGenerations = true;
        showStoreSize = true;
        updateInterval = 3600;
        updateCheckInterval = 3600;
        gcThresholdGB = 100;
      };
      config = {
        generationsCommand = [
          "sh"
          "-c"
          "ls -1 /nix/var/nix/profiles | grep -e 'system-' | wc -l"
        ];
        storeSizeCommand = [
          "sh"
          "-c"
          "du -sh /nix/store 2>/dev/null | cut -f1"
        ];
        gcCommand = [
          "sh"
          "-c"
          "nix-collect-garbage -d 2>&1"
        ];
        localRevisionCommand = [
          "sh"
          "-c"
          "nixos-version --hash 2>/dev/null | cut -c 1-7 || echo 'N/A'"
        ];
        remoteRevisionCommand = [
          "sh"
          "-c"
          "git ls-remote https://github.com/NixOS/nixpkgs.git nixos-unstable 2>/dev/null | cut -c 1-7 || echo 'N/A'"
        ];
        nixpkgsChannel = "nixos-unstable";
        updateInterval = 300;
        rebuildCommand = [
          "sh"
          "-c"
          "sudo nixos-rebuild switch --flake .#$(hostname)"
        ];
      };
    };
    localServices = {
      enable = true;
      settings = {
        ignoredPorts = "";
        exactWatches = "";
        labels = "{}";
      };
    };
    scratchpadHelper = {
      enable = true;
      settings = {
        hideBarWhenEmpty = true;
        namedManagerEnabled = false;
      };
    };
    developerUtilities.enable = true;
  };

  mergeDefault = name: source: source // (enabledDefaults.${name} or { });
in
lib.mapAttrs mergeDefault sources
// lib.filterAttrs (name: _: !(lib.hasAttr name sources)) enabledDefaults
