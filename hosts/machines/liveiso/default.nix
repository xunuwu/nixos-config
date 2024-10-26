{pkgs, ...}: {
  imports = [
    ./tools.nix
    ./sway.nix
  ];

  environment.systemPackages = with pkgs; [
    firefox
  ];

  isoImage.edition = "sway-custom";

  networking.hostName = "liveiso";

  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "23.11";
}
