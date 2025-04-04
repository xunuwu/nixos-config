{pkgs, ...}: {
  stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      dark = "Adwaita-dark";
    };
    targets.firefox.profileNames = ["xun"];
  };
}
