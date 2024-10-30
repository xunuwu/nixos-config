{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.xun.desktop;
in {
  options.xun.desktop = {
    xdg.enable = lib.mkEnableOption "xdg env vars";
  };

  config = lib.mkIf cfg.xdg.enable {
    xdg = let
      home = config.home.homeDirectory;
    in {
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
  };
}
