{pkgs, ...}: {
  imports = [
    ./fuzzel.nix
    ./waybar.nix
  ];

  stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.morewaita-icon-theme;
      dark = "MoreWaita";
    };

    targets = {
      firefox.enable = true;
      # firefox.colorTheme.enable = true;
      firefox.profileNames = ["xun"];
      gtk.enable = true;
      qt.enable = true;
      foot.enable = true;
      swaync.enable = true;
    };
  };
}
