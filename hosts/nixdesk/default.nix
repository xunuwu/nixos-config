{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware.nix
  ];

  networking.hostName = "nixdesk";

  swapDevices = [];

  system.stateVersion = "23.11";
}
