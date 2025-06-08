{vars, ...}: {
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      session.COOKIE_SECURE = true;
      server = {
        DOMAIN = "git.${vars.domain}";
        ROOT_URL = "https://git.${vars.domain}";
        HTTP_PORT = 3000;
        HTTP_ADDR = "127.0.0.1";
      };
      service.DISABLE_REGISTRATION = true;
    };
  };
  services.restic.backups.rackserv.paths = ["/var/lib/forgejo/dump"];
}
