{config, ...}: {
  systemd.services.vaultwarden = {
    serviceConfig.EnvironmentFile = config.sops.secrets.vaultwarden-env.path;
  };
  # NOTE send doesnt work, probably due to my cloudflare port rewriting rules
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vw.xunuwu.xyz";
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 35381;
      ROCKET_LOG = "critical";
      SIGNUPS_ALLOWED = false;
      IP_HEADER = "X-Forwarded-For";
    };
  };

  environment.persistence."/persist".directories = ["/var/lib/bitwarden_rs"];
  services.restic.backups.hopper.paths = ["/var/lib/bitwarden_rs"];
}
