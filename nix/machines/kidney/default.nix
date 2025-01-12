{
  imports = [
    ./wsl.nix
    ./hardware.nix
    ./fonts.nix

    ../../systemProfiles/core/tools.nix
    ../../systemProfiles/core/users.nix
    ../../systemProfiles/core/locale.nix

    ../../systemProfiles/programs/tools.nix
    ../../systemProfiles/programs/zsh.nix
    ../../systemProfiles/programs/home-manager.nix
    ../../systemProfiles/hardware/graphics.nix

    ../../systemProfiles/services/flatpak.nix
    ../../systemProfiles/services/xdg-portals.nix

    ../../systemProfiles/nix/default.nix
    ../../systemProfiles/nix/gc.nix
  ];

  networking.hostName = "kidney";

  system.stateVersion = "24.05";
}
