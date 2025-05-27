{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
  };

  environment.persistence."/persist".directories = ["/var/lib/tailscale"];
}
