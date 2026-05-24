{
  vars,
  config,
  ...
}: {
  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.secrets.miniflux.path;
    config = {
      BASE_URL = "https://rss.${vars.domain}";
      LISTEN_ADDR = "127.0.0.1:18632";
    };
  };
}
