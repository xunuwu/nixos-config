{pkgs, ...}: {
  imports = [
    ./fuzzel.nix
    ./waybar.nix
  ];

  stylix = {
    icons = {
      enable = true;
      package = pkgs.morewaita-icon-theme;
      dark = "MoreWaita";
    };

    targets = {
      firefox.enable = true;
      # firefox.colorTheme.enable = true;
      firefox.profileNames = ["xun"];
      gtk.enable = true;
      qt.enable = false;
      foot.enable = true;
      swaync.enable = true;
      gnome.enable = true;
      kde.enable = false;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
    kde.settings.kdeglobals = {
      General.ColorScheme = "BreezeDark";
      KDE.colorScheme = "BreezeDark";
    };
  };
}
