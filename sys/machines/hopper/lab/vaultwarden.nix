{config, ...}: {
  systemd.services.vaultwarden = {
    serviceConfig.EnvironmentFile = config.sops.secrets.vaultwarden-env.path;
  };
  # NOTE send doesnt work, probably due to my cloudflare port rewriting rules
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://${config.services.caddy.virtualHosts.vw.hostName}";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 35381;
      ROCKET_LOG = "critical";
      SIGNUPS_ALLOWED = false;
    };
  };

  services.restic.backups.hopper.paths = ["/var/lib/bitwarden_rs"];
}
