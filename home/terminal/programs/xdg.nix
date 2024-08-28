# TODO: move this somewhere more reasonable
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
      desktop = home + "/desktop";
      documents = home + "/docs";
      download = home + "/down";
      music = home + "/music";
      pictures = home + "/pics";
      publicShare = home + "/share";
      videos = home + "/vids";
      extraConfig = {
        XDG_SCREENSHOTS_DIR = config.xdg.userDirs.pictures + "/screenshots";
      };
    };
  };

  home.packages = [pkgs.xdg-utils];
}
