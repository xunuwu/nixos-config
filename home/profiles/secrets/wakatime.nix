{config, ...}: {
  sops.secrets.wakatime = {
    format = "binary";
    sopsFile = ./wakatime;
    path = "${config.home.homeDirectory}/.wakatime.cfg";
  };
}
