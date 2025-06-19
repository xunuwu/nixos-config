{
  homeProfiles,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = with homeProfiles; [
    cli.xdg
    cli.comma

    programs.nvim
    programs.foot

    desktop.xdg-portals
    desktop.sway.default

    programs.mpv

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

    moonlight-qt
    inputs.sobercookie.packages.${pkgs.system}.default
  ];

  home = {
    username = "desktop";
    homeDirectory = lib.mkForce "/home/desktop";
  };
  programs.home-manager.enable = true;
}
