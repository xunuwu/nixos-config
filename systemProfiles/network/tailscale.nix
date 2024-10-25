{
  self,
  super,
  root,
}: {config, ...}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
    #authKeyFile = config.sops.secrets.tailscale-auth.path;
  };
}
