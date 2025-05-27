{
  services.jellyfin.enable = true;

  environment.persistence."/persist".directories = ["/var/lib/jellyfin"];
  services.restic.backups.hopper.paths = [
    "/var/lib/jellyfin/data"
    "/var/lib/jellyfin/config"
  ];
}
