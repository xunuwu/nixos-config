{inputs, ...}: {
  imports = with inputs.hardware.nixosModules; [
    common-cpu-intel

    ./hardware.nix
    ./brawlstats.nix
  ];

  networking.hostName = "hopper";

  swapDevices = [];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
