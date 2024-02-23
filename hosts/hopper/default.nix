{inputs, ...}: {
  imports = with inputs.hardware.nixosModules; [
    common-cpu-intel
    common-pc-hdd

    ./hardware.nix
  ];

  networking.hostName = "hopper";

  #services.tailscale.extraUpFlags = [
  #  "--ssh"
  #];

  swapDevices = [];

  system.stateVersion = "23.11";
}
