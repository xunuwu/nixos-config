{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.xun.desktop;
in {
  imports = [
    ./colorscheme
  ];

  options.xun.desktop = {
    xdg.enable = lib.mkEnableOption "xdg env vars";
    # colorscheme = lib.mkOption {
    #   default = null;
    #   type = lib.types.enum ["dark" "light"];
    # };
  };

  config = lib.mkMerge [
    # (let
    #   switch = {
    #     "dark" = {};
    #     "light" = {};
    #   };
    # in
    #   switch."${toString cfg.colorscheme}")

    (lib.mkIf cfg.xdg.enable {
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
    })
  ];
}
