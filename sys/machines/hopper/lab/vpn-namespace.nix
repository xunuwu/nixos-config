{
  config,
  lib,
  ...
}: {
  vpnNamespaces."wg" = {
    enable = true;
    wireguardConfigFile = config.sops.secrets.wireguard.path;
    accessibleFrom = [
      "192.168.0.0/24"
      # "127.0.0.1"
    ];

    # Forwarded to my vpn, for making things accessible from outside
    openVPNPorts = [
      {
        port = 8336;
        protocol = "tcp";
      }
      {
        port = config.services.slskd.settings.soulseek.listen_port;
        protocol = "both";
      }
      {
        port = config.services.slskd.settings.soulseek.listen_port + 1;
        protocol = "both";
      }
      {
        port = config.services.transmission.settings.peer-port;
        protocol = "both";
      }
    ];

    # From inside of the vpn namespace to outside of it, for making things inside accessible to LAN
    portMappings = let
      passthrough = [
        8336 # caddy
        80 # caddy
        443 # caddy
        1900 # jellyfin discovery
        7359 # jellyfin discovery
      ];
    in (lib.map (x: {
        from = x;
        to = x;
      })
      passthrough);
  };
}
