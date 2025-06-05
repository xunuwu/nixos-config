{
  pkgs,
  config,
  lib,
  ...
}: {
  networking.firewall = let
    forwardPorts = {
      "10.0.0.2" =
        [24001 24002 24003 443 80]
        |> map (n: {
          protocols = ["tcp"];
          port = n;
        });
      "10.0.0.3" =
        lib.range 23000 23010
        |> map (n: {
          protocols = ["tcp" "udp"];
          port = n;
        });
      "10.0.0.4" = [
        {
          protocols = ["tcp"];
          port = 22000;
        }
      ];
    };
    externalIp = "172.245.52.19";
    b = builtins;
    portsList = b.attrValues forwardPorts |> b.concatLists;
    portsAndIpsList = lib.mapAttrsToList (n: v: map (x: x // {destinationIp = n;}) v) forwardPorts |> b.concatLists;
  in {
    allowedTCPPorts = b.filter (x: b.elem "tcp" x.protocols) portsList |> map (x: x.port);
    allowedUDPPorts = [51820] ++ (b.filter (x: b.elem "udp" x.protocols) portsList |> map (x: x.port));
    extraCommands =
      portsAndIpsList
      |> map (x:
        x.protocols
        |> map (protocol: ''
          iptables -t nat -A PREROUTING -p ${protocol} -d ${externalIp} --dport ${toString x.port} -j DNAT --to-destination ${x.destinationIp}
        ''))
      |> b.concatLists
      |> b.concatStringsSep "\n";

    extraStopCommands =
      portsAndIpsList
      |> map (x:
        x.protocols
        |> map (protocol: ''
          iptables -t nat -D PREROUTING  -p ${protocol} -d ${externalIp} --dport ${toString x.port} -j DNAT --to-destination ${x.destinationIp} || true
        ''))
      |> b.concatLists
      |> b.concatStringsSep "\n";

    interfaces.wg0 = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53];
    };
  };

  systemd.network.netdevs = {
    "50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
        MTUBytes = "1420";
      };
      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = config.sops.secrets.wireguard-privatekey.path;
        RouteTable = "main";
      };
      wireguardPeers = [
        {
          # hopper
          PublicKey = "P5W5/m9VnWcbdR6e3rs4Yars4Qb2rPjkRmCAbgja4Ug=";
          AllowedIPs = ["10.0.0.2" "fd12:1e51:ca23::2"];
        }
        {
          # nixdesk
          PublicKey = "DMauL/fv08yXvVtyStsUfg/OM+ZJwMNvguQ59X/KU2Q=";
          AllowedIPs = ["10.0.0.3" "fd12:1e51:ca23::3"];
        }
        {
          # alka
          PublicKey = "Q90dKQtQTu8RLgkPau7/Y5fY3PVstP0bL6ey3zrdS18=";
          AllowedIPs = ["10.0.0.4" "fd12:1e51:ca23::3"];
        }
      ];
    };
  };

  systemd.network.networks.wg0 = {
    matchConfig.Name = "wg0";
    address = ["10.0.0.1/10" "fd12:1e51:ca23::1/64"];
    networkConfig = {
      IPMasquerade = "ipv4";
      IPv4Forwarding = true;
    };
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      server = ["1.1.1.1" "8.8.8.8"];
      interface = ["wg0"];
      bind-interfaces = true;
    };
  };
}
