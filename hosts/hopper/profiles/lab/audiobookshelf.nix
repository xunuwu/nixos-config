{config, ...}: {
  services.audiobookshelf = {
    enable = true;
    port = 8009;
  };

  environment.persistence."/persist".directories = ["/var/lib/${config.services.audiobookshelf.dataDir}"];
  services.restic.backups.hopper.paths = [
    "/var/lib/${config.services.audiobookshelf.dataDir}"
  ];
}
