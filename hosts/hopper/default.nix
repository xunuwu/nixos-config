{inputs, ...}: {
  imports = with inputs.hardware.nixosModules; [
    common-cpu-intel
    common-pc-hdd

    ./hardware.nix
    ./brawlstats.nix
  ];

  services.tailscale.extraUpFlags = [
    "--ssh"
  ];

  networking.hostName = "hopper";

  swapDevices = [];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
