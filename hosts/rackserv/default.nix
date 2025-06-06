{
  inputs,
  systemProfiles,
  ...
}: {
  imports =
    [
      "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
      inputs.impermanence.nixosModules.impermanence
      inputs.disko.nixosModules.disko
      ./disks.nix
      ./profiles/fail2ban.nix
      ./profiles/wireguard-server.nix
      ./profiles/backups.nix
      ./profiles/caddy.nix
    ]
    ++ (with systemProfiles; [
      core.security
      core.tools
      core.ssh
      core.deploy

      nix.nix

      network.tailscale
      network.networkd
    ]);

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.firewall.logRefusedConnections = false; # this spams my journal too much

  hardware.enableRedistributableFirmware = true;

  environment.persistence."/persist".enable = false;

  networking.hostName = "rackserv";

  nixpkgs.hostPlatform.system = "x86_64-linux";
  system.stateVersion = "25.05";
}
