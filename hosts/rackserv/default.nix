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
