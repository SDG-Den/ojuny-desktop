{
  description = "Ojuny Desktop - pre-configured mangoWM + DankMaterialShell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      inherit (lib.fileset) toList fileFilter;

      isNixModule = file:
        file.hasExt "nix"
        && file.name != "flake.nix"
        && !lib.hasPrefix "_" file.name;

      importTree = path: toList (fileFilter isNixModule path);
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = importTree ./modules ++ [
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      flake = {
        nixosModules.default = self.modules.nixos.ojuny-desktop;
        homeManagerModules.default = self.modules.homeManager.ojuny-desktop;
        homeModules.default = self.modules.homeManager.ojuny-desktop;
      };
    };
}
