## TODO look into sops-nix placeholders
## reference: https://github.com/javigomezo/nixos/blob/b3ebe8d570ea9b37aea8bb3a343f6e16e054e322/services/network/authelia/user_database.nix
{
  imports = [
    ./acme.nix
    ./adguard.nix
    ./audiobookshelf.nix
    ./caddy.nix
    ./glances.nix
    ./homepage.nix
    ./minecraft.nix
    ./navidrome
    ./prometheus.nix
    ./restic.nix
    ./samba.nix
    ./slskd.nix
    ./transmission.nix
    ./vaultwarden.nix
    ./vpn-namespace.nix
  ];

  users.groups.media = {};
  users.users.media = {
    isSystemUser = true;
    group = "media";
  };

  networking.firewall = {
    allowedUDPPorts = [1900 7359]; # Jellyfin auto-discovery
    allowedTCPPorts = [
      # caddy lan ports
      80
      443
      2345
    ];
  };

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 99999999;
}
