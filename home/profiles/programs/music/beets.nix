{pkgs, ...}: let
  musicDir = "/home/xun/music/test";
in {
  programs.beets = {
    enable = true;
    package = pkgs.beets-unstable;
    settings = {
      directory = "${musicDir}/tagged";
      library = "${musicDir}/beets/beets.db";

      # import = {
      # };

      plugins = [
        "rewrite"
      ];
      rewrite = {
        "artist GHOST" = "Ghost and Pals";
      };

      # plugins = [
      # ];
    };
  };
}
