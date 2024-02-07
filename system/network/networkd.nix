{
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks."10-lan" = {
      matchConfig.Name = "lan";
      networkConfig.DHCP = "ipv4";
    };
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
  };
}
