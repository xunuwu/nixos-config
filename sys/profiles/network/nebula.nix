{config, ...}: {
  services.nebula.networks.xunmesh = {
    enable = true;
    staticHostMap = {
      "30.0.0.1" = ["172.245.52.19:3131"];
    };
    cert = config.sops.secrets.nebula-cert.path;
    key = config.sops.secrets.nebula-key.path;
    ca = config.sops.secrets.nebula-ca-cert.path;
    listen.port = 3131;
    firewall = {
      inbound = [
        {
          host = "any";
          port = "any";
          proto = "any";
        }
      ];
      outbound = [
        {
          host = "any";
          port = "any";
          proto = "any";
        }
      ];
    };
    settings = {
      preferred_ranges = ["192.168.50.0/24"];
      lighthouse.hosts = ["30.0.0.1"];
      punchy.punch = true;
    };
  };

  networking.firewall.trustedInterfaces = ["nebula.xunmesh"]; # bypass nixos firewall
}
