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
      metrics = {
        ENABLED = true;
        ENABLED_ISSUE_BY_LABEL = true;
        ENABLED_ISSUE_BY_REPOSITORY = true;
      };
      service.DISABLE_REGISTRATION = true;
    };
  };
  services.restic.backups.rackserv.paths = ["/var/lib/forgejo/dump"];
}
