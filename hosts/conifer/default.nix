{
  lib,
  pkgs,
  inputs,
  systemProfiles,
  specialArgs,
  ...
}: {
  imports =
    [
      ./hardware.nix

      inputs.impermanence.nixosModules.impermanence

      {
        home-manager = {
          backupFileExtension = "hm-backup";
          users.xun.imports = [
            ./home.nix
            {home.stateVersion = "25.05";}
          ];
          extraSpecialArgs = specialArgs;
        };
      }
    ]
    ++ (with systemProfiles; [
      core.security
      core.users
      core.locale
      core.tools
      core.compat

      programs.zsh
      programs.fish

      nix.nix
      nix.gc

      hardware.graphics
      hardware.bluetooth

      services.flatpak
      services.xdg-portals

      network.avahi

      programs.home-manager
      programs.tools
    ]);

  environment.persistence."/persist".enable = false;

  networking.hostName = "conifer";
  system.stateVersion = "25.05";
}
