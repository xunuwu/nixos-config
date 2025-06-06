{
  homeProfiles,
  lib,
  pkgs,
  ...
}: {
  imports = map (x: homeProfiles + x) [
    /cli/xdg.nix
    /cli/comma.nix

    /programs/nvim.nix
    /programs/foot.nix

    /desktop/xdg-portals.nix
    /desktop/sway/default.nix

    /programs/mpv.nix

    /services/playerctl.nix
    /services/polkit-agent.nix
  ];

  wayland.windowManager.sway.config.output."HDMI-A-1".scale = "2.0";

  services = {
    udiskie.enable = true;
  };
  home.packages = with pkgs; [
    pwvucontrol
    qpwgraph

    stremio
    moonlight-qt
  ];

  home = {
    username = "desktop";
    homeDirectory = lib.mkForce "/home/desktop";
  };
  programs.home-manager.enable = true;
}
