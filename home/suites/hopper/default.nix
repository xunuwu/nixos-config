{
  homeProfiles,
  lib,
  ...
}: {
  imports = with homeProfiles; [
    terminal.programs.xdg
    terminal.programs.comma

    editors.nvim
    terminal.emulator.foot

    programs.desktop.default
    programs.desktop.sway.default

    programs.misc.pwvucontrol
    programs.misc.qpwgraph

    programs.media.mpv
    programs.media.stremio

    services.playerctl
    services.polkit-agent
    services.udiskie
  ];

  wayland.windowManager.sway.config.output."HDMI-A-1".scale = "2.0";

  home = {
    username = "desktop";
    homeDirectory = lib.mkForce "/home/desktop";
  };
  programs.home-manager.enable = true;
}
