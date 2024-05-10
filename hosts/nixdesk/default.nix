{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "nixdesk";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
