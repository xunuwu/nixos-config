{
  services.restic.server = {
    enable = true;
    dataDir = "/srv/backup";
    extraFlags = ["--no-auth"];
  };
}
