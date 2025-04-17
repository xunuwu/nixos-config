{pkgs, ...}: {
  imports = [
    ./fuzzel.nix
    ./waybar.nix
  ];

  stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      dark = "Adwaita-dark";
    };
    targets = {
      firefox.profileNames = ["xun"];
      gtk.enable = true;
      qt.enable = true;
      foot.enable = true;
      firefox.enable = true;
      swaync.enable = true;
    };
  };
}
