{
  config,
  pkgs,
  ...
}: {
  #networking.wg-quick.interfaces."wg0".configFile = config.sops.secrets.wireguard.path;

  # Sets tailscale to a high priority, to make sure tailscale
  # traffic dosent go through wireguard (which wont work)
  #systemd.services.tailscaled.serviceConfig = {
  #  ExecStartPost = "${pkgs.iproute2}/bin/ip rule add pref 65 table 52";
  #  ExecStopPost = "${pkgs.iproute2}/bin/ip rule del pref 65 table 52";
  #};

  ## https://wiki.archlinux.org/title/WireGuard#systemd-networkd:_routing_all_traffic_over_WireGuard
  #environment.systemPackages = [pkgs.wireguard-tools];

  #systemd.network = {
  #  netdevs."99-wg0" = {
  #    netdevConfig = {
  #      Name = "wg0";
  #      Kind = "wireguard";
  #      Description = "WireGuard tunnel wg0";
  #    };
  #    wireguardConfig = {
  #      ListenPort = 51871;
  #      PrivateKeyFile = config.sops.secrets.wg-private.path;
  #    };
  #    wireguardPeers = [
  #      {
  #        wireguardPeerConfig = {
  #          PublicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
  #          PresharedKeyFile = config.sops.secrets.wg-preshared.path;
  #          AllowedIPs = [
  #            "0.0.0.0"
  #          ];
  #          Endpoint = "62.102.148.206:1637";
  #        };
  #      }
  #    ];
  #  };
  #  networks."50-wg0" = {
  #    name = "wg0";

  #    address = ["10.154.4.37/24"];
  #    dns = ["10.128.0.1"];
  #    domains = ["~."];
  #    networkConfig = {
  #      DNSDefaultRoute = true;
  #    };

  #    routingPolicyRules = [
  #      {
  #        routingPolicyRuleConfig = {
  #          FirewallMark = 34952;
  #          InvertRule = true;
  #          Table = 1000;
  #          Priority = 10;
  #        };
  #      }
  #      {
  #        ## Allow local connections
  #        routingPolicyRuleConfig = {
  #          To = "192.168.0.0/24";
  #          Priority = 9;
  #        };
  #      }
  #    ];

  #    routes = [
  #      {
  #        routeConfig = {
  #          Gateway = "10.128.0.1";
  #          GatewayOnLink = true;
  #          Table = 1000;
  #        };
  #      }
  #    ];
  #  };
  #};
}
