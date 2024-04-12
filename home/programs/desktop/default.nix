{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-kde
    ];
    config = {
      preferred = {
        default = "hyprland;gtk";
        "org.freedesktop.impl.portal.FileChooser" = "kde";
      };
    };
  };
}
