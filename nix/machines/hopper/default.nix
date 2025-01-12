{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.vpn-confinement.nixosModules.default

    ./hardware.nix
    ./newlab.nix

    ../../systemProfiles/secrets/default.nix
    ../../systemProfiles/secrets/hopper/default.nix

    ../../systemProfiles/core/security.nix
    ../../systemProfiles/core/locale.nix
    ../../systemProfiles/core/tools.nix
    ../../systemProfiles/core/ssh.nix
    ../../systemProfiles/core/deploy.nix

    ../../systemProfiles/nix/default.nix # TODO slim this down

    ../../systemProfiles/network/tailscale.nix
    ../../systemProfiles/network/avahi.nix
    ../../systemProfiles/network/networkd.nix

    # ../../services/syncthing.nix # TODO make syncthing not rely on having "xun" user
  ];

  networking.hostName = "hopper";

  swapDevices = [];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
