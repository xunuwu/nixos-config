{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
    extraSetFlags = ["--advertise-exit-node"];
  };

  environment.persistence."/persist".directories = ["/var/lib/tailscale"];
}
