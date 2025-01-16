{
  specialArgs,
  systemProfiles,
  homeSuites,
  ...
}: {
  imports = with systemProfiles; [
    ./wsl.nix
    ./hardware.nix
    ./fonts.nix

    core.tools
    core.users
    core.locale

    programs.tools
    programs.zsh
    programs.home-manager
    hardware.graphics

    services.flatpak
    services.xdg-portals

    nix.default
    nix.gc

    {
      home-manager = {
        users.xun.imports = [
          homeSuites.kidney
          {home.stateVersion = "24.05";}
        ];
        extraSpecialArgs = specialArgs;
      };
    }
  ];

  networking.hostName = "kidney";

  system.stateVersion = "24.05";
}
