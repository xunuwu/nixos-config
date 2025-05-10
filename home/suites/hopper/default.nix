{
  homeProfiles,
  lib,
  pkgs,
  ...
}: {
  imports = map (x: homeProfiles + x) [
    /terminal/programs/xdg.nix
    /terminal/programs/comma.nix

    /editors/nvim.nix
    /terminal/emulator/foot.nix

    /programs/desktop/default.nix
    /programs/desktop/sway/default.nix

    /programs/media/mpv.nix

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
