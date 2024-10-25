{pkgs, ...}: {
  services.samba = {
    enable = true;
    package = pkgs.samba4Full;
    openFirewall = true;
    shares = {
      "torrent" = {
        path = "/media/downloads";
        browseable = "yes";
        "guest ok" = "yes";
        "read only" = "yes";
        "write list" = "xun";
      };
      "library" = {
        path = "/media/library";
        browseable = "yes";
        "guest ok" = "yes";
        "read only" = "yes";
        "write list" = "xun";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
