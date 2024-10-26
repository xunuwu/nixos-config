{inputs, ...}: {
  imports = with inputs.hardware.nixosModules; [
    common-cpu-intel

    inputs.vpn-confinement.nixosModules.default

    ./hardware.nix
    ./brawlstats.nix
    ./lab.nix
    ./hardening.nix
  ];

  networking.hostName = "hopper";

  swapDevices = [];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
