{
  config,
  lib,
  vars,
  ...
}: let
  peers = vars.hosts.rackserv.wireguardPeers;
in {
  networking.firewall = let
    externalIp = "172.245.52.19";
    b = builtins;
    isIpv4 = ip: b.match "([0-9]{1,3}\.){3}[0-9]{1,3}" ip != null;
    forPortIps = f:
      lib.concatStrings (
        b.concatMap (
          peer:
            lib.cartesianProduct {
              IP = peer.IPs;
              port = peer.OpenPorts;
            }
            |> b.filter (x: isIpv4 x.IP)
            |> map f
        )
        peers
      );
    getPortsWithProtocol = protocol:
      b.concatMap (peer:
        peer.OpenPorts
        |> b.filter (portInfo: portInfo.protocol == protocol)
        |> map (portInfo: portInfo.port))
      peers;
  in {
    allowedTCPPorts = getPortsWithProtocol "tcp";
    allowedUDPPorts = getPortsWithProtocol "udp";
    extraCommands = forPortIps ({
      IP,
      port,
    }: ''
      iptables -t nat -A PREROUTING -p ${port.protocol} -d ${externalIp} --dport ${toString port.port} -j DNAT --to-destination ${IP}
      iptables -t nat -A POSTROUTING -p ${port.protocol} -d ${IP} --dport ${toString port.port} -j SNAT --to-source ${externalIp}
    '');
    extraStopCommands = forPortIps ({
      IP,
      port,
    }: ''
      iptables -t nat -D PREROUTING -p ${port.protocol} -d ${externalIp} --dport ${toString port.port} -j DNAT --to-destination ${IP} || true
      iptables -t nat -D POSTROUTING -p ${port.protocol} -d ${IP} --dport ${toString port.port} -j SNAT --to-source ${externalIp} || true
    '');

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
      wireguardPeers =
        map (peer: {
          inherit (peer) PublicKey;
          AllowedIPs = peer.IPs;
        })
        peers;
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
