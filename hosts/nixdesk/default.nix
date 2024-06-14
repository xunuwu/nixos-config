{
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "nixdesk";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
