{config, ...}: {
  systemd.services.vaultwarden = {
    serviceConfig.EnvironmentFile = config.sops.secrets.vaultwarden-env.path;
  };
  # NOTE send doesnt work, probably due to my cloudflare port rewriting rules
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://${config.services.caddy.virtualHosts.vaultwarden.hostName}";
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 35381;
      ROCKET_LOG = "critical";
      SIGNUPS_ALLOWED = false;
      IP_HEADER = "X-Forwarded-For";
    };
  };

  services.restic.backups.hopper.paths = ["/var/lib/bitwarden_rs"];
}
