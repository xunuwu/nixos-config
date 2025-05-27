{
  config,
  pkgs,
  ...
}: {
  services.navidrome = {
    enable = true;
    package = pkgs.navidrome.overrideAttrs {
      patches = [./scrobbleAlbumArtist.patch];
      doCheck = false;
    };
    settings = {
      MusicFolder = "/media/library/music";
      Address = config.vpnNamespaces."wg".bridgeAddress;
      EnableSharing = true;
    };
  };
  systemd.services.navidrome.serviceConfig.EnvironmentFile = config.sops.secrets.navidrome.path;

  environment.persistence."/persist".directories = ["/var/lib/navidrome"];

  services.restic.backups.hopper = {
    paths = ["/var/lib/navidrome"];
    exclude = ["/var/lib/navidrome/cache"];
  };
}
