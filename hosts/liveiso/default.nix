{
  inputs,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    ./tools.nix
    ./sway.nix
  ];

  isoImage.edition = "sway-custom";

  networking.hostName = "liveiso";

  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "23.11";
}
