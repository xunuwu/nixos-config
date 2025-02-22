{config, ...}: {
  systemd.services.slskd.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.slskd = {
    enable = true;
    environmentFile = config.sops.secrets.slskd.path;
    domain = null; # why isnt this the default?
    settings = {
      metrics = {
        enabled = true;
        authentication.disabled = true;
      };
      remote_file_management = true;
      shares.directories = ["/media/library/music"];
      soulseek = {
        listen_port = 26449;
        description = "";
      };
      global = {
        upload = {
          slots = 50;
          speed_limit = 10000;
        };
        download.speed_limit = 10000;
      };
    };
  };
}
