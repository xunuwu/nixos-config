{
  lib,
  pkgs,
  ...
}: {
  stylix.targets = {
    firefox.profileNames = ["xun"];
  };
  gtk = {
    # theme = lib.mkForce {
    #   package = pkgs.whitesur-gtk-theme;
    #   name = "WhiteSur-Dark";
    # };
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
  };
}
