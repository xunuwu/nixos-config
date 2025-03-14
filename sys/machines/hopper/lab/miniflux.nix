{
  config,
  lib,
  ...
}: {
  systemd.services.miniflux.serviceConfig.RuntimeDirectoryMode = lib.mkForce "0755";

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.secrets.miniflux.path;
    config = {
      LISTEN_ADDR = "/run/miniflux/miniflux.sock";
    };
  };
}
