{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.xun.desktop;
  dark = {
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    gtk = {
      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita-dark";
      };
      gtk2.extraConfig = "gtk-application-prefer-dark-theme=1";
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };
    qt = {
      platformTheme.name = "gtk3";
      style = {
        name = "Adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };
  light = {
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-light";
    gtk = {
      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita";
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      gtk2.extraConfig = "gtk-application-prefer-dark-theme=false";
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 0;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 0;
    };
    qt = {
      style = {
        name = "adwaita";
        package = pkgs.adwaita-qt;
      };
    };
  };
in {
  options.xun.desktop.colorscheme = lib.mkOption {
    default = null;
    type = lib.types.enum [null "dark" "light"]; # might add more in the future
  };

  config = lib.mkIf (cfg.colorscheme != null) (lib.mkMerge [
    (lib.mkIf (cfg.colorscheme == "dark") dark)
    (lib.mkIf (cfg.colorscheme == "light") light)
  ]);

  # config = lib.mkIf (cfg.colorscheme != null) (let
  #   switch = {
  #     dark = {};
  #     light = {};
  #   };
  # in
  #   switch."${toString cfg.colorscheme}");
}
