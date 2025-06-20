{
  config,
  lib,
  ...
}: {
  networking.firewall = let
    allowTcpFromVPNToDefaultPorts = [
      config.services.prometheus.port
      config.services.prometheus.alertmanager.port
      config.services.vaultwarden.config.ROCKET_PORT
      config.services.homepage-dashboard.listenPort
      config.services.audiobookshelf.port
      config.services.navidrome.settings.Port
      config.services.glances.port
      18632
    ];
  in {
    extraCommands = builtins.concatStringsSep "\n" (map
      (port: "iptables -A nixos-fw -p tcp -s ${config.vpnNamespaces."wg".namespaceAddress} --dport ${toString port} -j nixos-fw-accept")
      allowTcpFromVPNToDefaultPorts);
    extraStopCommands = builtins.concatStringsSep "\n" (
      map
      (port: "iptables -D nixos-fw -p tcp -s ${config.vpnNamespaces."wg".namespaceAddress} --dport ${toString port} -j nixos-fw-accept || true")
      allowTcpFromVPNToDefaultPorts
    );
  };

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
        port = 443; # caddy
        protocol = "tcp";
      }
      {
        port = 80; # caddy
        protocol = "tcp";
      }

      {
        port = 24001; # slskd
        protocol = "both";
      }
      {
        port = 24002; # slskd
        protocol = "both";
      }
      {
        port = 24003; # transmission
        protocol = "both";
      }
    ];

    # From inside of the vpn namespace to outside of it, for making things inside accessible to LAN
    portMappings = let
      passthrough = [
        8336 # caddy
        80 # caddy
        443 # caddy
        2019 # caddy admin, for prometheus metrics
        config.services.transmission.settings.rpc-port
        config.services.slskd.settings.web.port
      ];
    in (lib.map (x: {
        from = x;
        to = x;
      })
      passthrough);
  };
}
