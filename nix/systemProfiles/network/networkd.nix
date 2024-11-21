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

  # TODO use networkd-dispatcher to do some things when network connectivity changes maybe
}
