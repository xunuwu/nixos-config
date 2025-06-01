{
  pkgs,
  config,
  lib,
  ...
}: {
  networking.firewall = let
    forwardPorts = {
      "10.0.0.3" =
        lib.range 23000 23010
        |> map (n: {
          protocols = ["tcp" "udp"];
          port = n;
        });
      "10.0.0.2" =
        [24001 24002 24003]
        |> map (n: {
          protocols = ["tcp"];
          port = n;
        });
    };

    b = builtins;
    portsList = b.attrValues forwardPorts |> b.concatLists;
    portsAndIpsList = lib.mapAttrsToList (n: v: map (x: x // {destinationIp = n;}) v) forwardPorts |> b.concatLists;
  in {
    allowedTCPPorts = b.filter (x: b.elem "tcp" x.protocols) portsList |> map (x: x.port);
    allowedUDPPorts = [51820] ++ (b.filter (x: b.elem "udp" x.protocols) portsList |> map (x: x.port));
    extraCommands =
      portsAndIpsList
      |> map (x: ''
        ${x.protocols |> map (protocol: "iptables -t nat -A PREROUTING  -p ${protocol} --dport ${toString x.port} -j DNAT --to-destination ${x.destinationIp}") |> b.concatStringsSep "\n"}
        ${x.protocols |> map (protocol: "iptables -t nat -A POSTROUTING -p ${protocol} -d ${x.destinationIp} --dport ${toString x.port} -j SNAT --to-source 172.245.52.19") |> b.concatStringsSep "\n"}
      '')
      |> b.concatStringsSep "\n";

    extraStopCommands =
      portsAndIpsList
      |> map (x: ''
        ${x.protocols |> map (protocol: "iptables -t nat -D PREROUTING  -t nat -p ${protocol} --dport ${toString x.port} -j DNAT --to-destination ${x.destinationIp}") |> b.concatStringsSep "\n"}
        ${x.protocols |> map (protocol: "iptables -t nat -D POSTROUTING -t nat -p ${protocol} -d ${x.destinationIp} --dport ${toString x.port} -j SNAT --to-source 172.245.52.19") |> b.concatStringsSep "\n"}
      '')
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
        MTUBytes = "1300";
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

  # networking.wireguard = {
  #   enable = true;
  #   interfaces.wg0 = {
  #     ips = ["10.0.0.0/10"];
  #     listenPort = 51820;
  #     postSetup = ''
  #       ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
  #     '';
  #     postShutdown = ''
  #       ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
  #     '';
  #
  #     privateKeyFile = config.sops.secrets.wireguard-privatekey.path;
  #
  #     peers = [
  #       {
  #         # hopper
  #         publicKey = "P5W5/m9VnWcbdR6e3rs4Yars4Qb2rPjkRmCAbgja4Ug=";
  #         allowedIPs = ["10.0.0.1/32"];
  #       }
  #     ];
  #   };
  # };
}
