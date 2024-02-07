{
  config,
  pkgs,
  ...
}: let
  home = config.home.homeDirectory;
in {
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = home + "/desktop";
      documents = home + "/docs";
      download = home + "/down";
      music = home + "/music";
      pictures = home + "/pics";
      publicShare = home + "/share";
      videos = home + "/vids";
    };
  };

  home.packages = [pkgs.xdg-utils];
}
