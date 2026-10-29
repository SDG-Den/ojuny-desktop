{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }: {
    packages.default = pkgs.callPackage ../../packages/desktop-runner {
      inherit inputs;
      mangowm = inputs.mangowm.packages.${system}.mango;
      duxPluginRegistry = inputs.dux-plugin-registry.packages.${system};
      duxGop = inputs.dux-gop.packages.${system}.default;
      duxSearch = inputs.dux-search.packages.${system}.default;
      duxCalendar = inputs.dux-calendar.packages.${system}.default;
      duxFiles = inputs.dux-files.packages.${system}.default;
    };

    packages.ojuny-WinMenu = pkgs.callPackage ../../packages/ojuny-winmenu { };
  };
}
