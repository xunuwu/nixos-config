{config, ...}: {
  users.groups.${config.services.navidrome.group}.members = ["caddy"]; # for caddy to access socket file
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/media/library/music";
      Address = "unix:/var/lib/navidrome/navidrome.sock";
      EnableSharing = true;
    };
  };
  systemd.services.navidrome.serviceConfig.EnvironmentFile = config.sops.secrets.navidrome.path;

  services.restic.backups.hopper = {
    paths = ["/var/lib/navidrome"];
    exclude = ["/var/lib/navidrome/cache"];
  };
}
