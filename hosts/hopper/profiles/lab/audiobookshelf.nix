{config, ...}: {
  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
  };

  environment.persistence."/persist".directories = ["/var/lib/${config.services.audiobookshelf.dataDir}"];
  services.restic.backups.hopper.paths = [
    "/var/lib/${config.services.audiobookshelf.dataDir}"
  ];
}
