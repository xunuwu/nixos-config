{
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
  };
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      Domains = ["~."];
    };
  };
}
