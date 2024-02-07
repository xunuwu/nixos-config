{pkgs, ...}: {
  xdg = {
    portal = {
      enable = true;
      config = {
        common.default = ["gtk"];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}
