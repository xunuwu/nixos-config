{
  vars,
  config,
  ...
}: {
  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.secrets.miniflux.path;
    config = {
      BASE_URL = "https://miniflux.${vars.domain}";
      LISTEN_ADDR = "${config.vpnNamespaces."wg".bridgeAddress}:18632";
    };
  };
}
