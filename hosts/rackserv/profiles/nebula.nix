{config, ...}: {
  networking.firewall.allowedTCPPorts = [3131];
  services.nebula.networks.xunmesh = {
    enable = true;
    isLighthouse = true;
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
  };
}
