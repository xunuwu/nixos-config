{inputs, ...}: {
  imports = with inputs.hardware.nixosModules; [
    common-cpu-intel
    common-pc-hdd

    ./hardware.nix
    ./brawlstats.nix
  ];

  networking.hostName = "hopper";

  swapDevices = [];

  system.stateVersion = "23.11";
}
