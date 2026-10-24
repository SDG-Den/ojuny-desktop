{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }: {
    packages.default = pkgs.callPackage ../../packages/desktop-runner {
      inherit inputs;
      mangowm = inputs.mangowm.packages.${system}.mango;
      dmsPluginRegistry = inputs.dms-plugin-registry.packages.${system};
    };
  };
}
