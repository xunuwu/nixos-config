{
  inputs,
  systemProfiles,
  ...
}: {
  imports = with systemProfiles; [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.vpn-confinement.nixosModules.default

    ./hardware.nix
    ./lab

    secrets.default
    secrets.hopper

    core.security
    core.locale
    core.tools
    core.ssh
    core.deploy

    nix.default # TODO slim this down

    network.tailscale
    network.avahi
    network.networkd

    # services.syncthing # TODO make syncthing not rely on having "xun" user
  ];

  networking.hostName = "hopper";

  swapDevices = [];

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
