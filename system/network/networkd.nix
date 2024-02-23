{
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
  };
}
