{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }: {
    packages.default = pkgs.callPackage ../../packages/desktop-runner {
      inherit inputs;
      mangowm = inputs.mangowm.packages.${system}.mango;
      dmsPluginRegistry = inputs.dms-plugin-registry.packages.${system};
      dgop = inputs.dgop.packages.${system}.dgop;
      dsearch = inputs.danksearch.packages.${system}.dsearch;
      dankcalendar = inputs.dankcalendar.packages.${system}.dankcalendar;
    };
  };
}
