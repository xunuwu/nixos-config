{
  imports = [
    ./wsl.nix
    ./hardware.nix
  ];

  networking.hostName = "kidney";

  system.stateVersion = "24.05";
}
