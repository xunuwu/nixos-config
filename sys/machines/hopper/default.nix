{
  inputs,
  systemProfiles,
  homeSuites,
  specialArgs,
  lib,
  ...
}: {
  imports = with systemProfiles; [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.vpn-confinement.nixosModules.default
    inputs.nix-minecraft.nixosModules.minecraft-servers

    ./hardware.nix
    ./lab
    ./desktop.nix

    secrets.default
    secrets.hopper

    programs.home-manager

    core.security
    core.locale
    core.tools
    core.ssh
    core.deploy

    hardware.graphics
    hardware.steam-hardware
    hardware.bluetooth

    nix.default # TODO slim this down

    network.tailscale
    network.avahi
    network.networkd

    # services.syncthing # TODO make syncthing not rely on having "xun" user

    {
      home-manager = {
        backupFileExtension = "hm-backup";
        users.desktop.imports = [
          homeSuites.hopper
          {home.stateVersion = "24.11";}
        ];
        extraSpecialArgs = specialArgs;
      };
    }
  ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"

        "stremio-shell"
        "stremio-server"
      ];
  };

  networking.hostName = "hopper";

  swapDevices = [];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
