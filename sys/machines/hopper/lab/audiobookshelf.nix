{config, ...}: {
  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
  };

  services.restic.backups.hopper.paths = [
    "/var/lib/${config.services.audiobookshelf.dataDir}"
  ];
}
