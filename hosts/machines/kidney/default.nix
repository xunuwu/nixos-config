{
  imports = [
    ./wsl.nix
    ./hardware.nix
    ./fonts.nix
  ];

  networking.hostName = "kidney";

  system.stateVersion = "24.05";
}
