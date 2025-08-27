{
  inputs,
  systemProfiles,
  specialArgs,
  lib,
  ...
}: {
  imports =
    [
      inputs.hardware.nixosModules.common-cpu-intel
      inputs.vpn-confinement.nixosModules.default
      inputs.nix-minecraft.nixosModules.minecraft-servers
      inputs.impermanence.nixosModules.impermanence

      ./hardware.nix
      ./profiles/lab
      ./profiles/roblox-playtime.nix
      ./profiles/desktop.nix
      ./profiles/persistent.nix

      {
        home-manager = {
          backupFileExtension = "hm-backup";
          users.desktop.imports = [
            ./home.nix
            {home.stateVersion = "24.11";}
          ];
          extraSpecialArgs = specialArgs;
        };
      }
    ]
    ++ (with systemProfiles; [
      programs.home-manager

      core.security
      core.locale
      core.tools
      core.ssh
      core.deploy

      hardware.graphics
      hardware.steam-hardware
      hardware.bluetooth

      nix.nix
      nix.gc

      services.flatpak

      network.tailscale
      network.avahi
      network.networkd
      network.nebula
    ]);

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
      ];
  };

  networking.hostName = "hopper";

  swapDevices = [];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
