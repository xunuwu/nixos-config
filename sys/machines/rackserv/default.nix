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
      ./disk-config.nix
      ./fail2ban.nix
      ./wireguard-server.nix
      ./backups.nix
      ./caddy.nix
    ]
    ++ (map (x: systemProfiles + x) [
      /core/security.nix
      /core/tools.nix
      /core/ssh.nix
      /core/deploy.nix

      /nix/default.nix

      /network/tailscale.nix
      /network/networkd.nix
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
