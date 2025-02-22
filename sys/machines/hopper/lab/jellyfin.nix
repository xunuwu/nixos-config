{
  systemd.services.jellyfin.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };
  services.jellyfin.enable = true;

  services.restic.backups.hopper.paths = [
    "/var/lib/jellyfin/data"
    "/var/lib/jellyfin/config"
  ];
}
