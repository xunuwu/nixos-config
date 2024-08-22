{lib}: {
  imports = [
    ./wsl.nix
  ];

  networking.hostName = "kidney";

  system.stateVersion = "24.05";
}
