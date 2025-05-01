{
  homeProfiles,
  lib,
  pkgs,
  ...
}: {
  imports = with homeProfiles; [
    terminal.programs.xdg
    terminal.programs.comma

    editors.nvim
    terminal.emulator.foot

    programs.desktop.default
    programs.desktop.sway.default

    programs.media.mpv

    services.playerctl
    services.polkit-agent
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
