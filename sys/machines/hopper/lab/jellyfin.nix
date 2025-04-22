{
  services.jellyfin.enable = true;

  services.restic.backups.hopper.paths = [
    "/var/lib/jellyfin/data"
    "/var/lib/jellyfin/config"
  ];
}
