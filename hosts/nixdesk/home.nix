{
  self,
  lib,
  pkgs,
  inputs,
  homeProfiles,
  ...
}: {
  imports = map (x: homeProfiles + x) [
    /default.nix

    /terminal/shell/zsh.nix
    /terminal/shell/fish.nix

    /terminal/programs/xdg.nix
    /terminal/programs/direnv.nix
    /terminal/programs/tmux.nix
    /terminal/programs/comma.nix
    /terminal/programs/irssi.nix
    /terminal/programs/git.nix
    /terminal/programs/github.nix
    /terminal/programs/jujutsu.nix

    /editors/nvim.nix

    /programs/browsers/firefox/default.nix
    /programs/browsers/tor.nix
    /programs/browsers/chromium.nix

    /terminal/emulator/foot.nix

    /themes/dark/default.nix

    # desktop
    /programs/desktop/default.nix
    /programs/desktop/sway/default.nix

    # development
    /develop/common.nix
    /develop/docs.nix

    /develop/langs/haskell.nix
    /develop/langs/go.nix
    /develop/langs/js.nix
    /develop/langs/rust.nix
    /develop/langs/elixir.nix
    /develop/langs/nix.nix
    /develop/langs/zig.nix
    /develop/langs/lua.nix
    /develop/langs/c.nix
    /develop/langs/csharp.nix

    # programs
    /programs/misc/discord.nix
    /programs/misc/obs.nix

    /programs/music/beets.nix
    /programs/music/cmus.nix

    /programs/media/mpv.nix

    # gaming
    /programs/games/default.nix
    /programs/games/jc141.nix

    /services/playerctl.nix
    /services/polkit-agent.nix
  ];

  wayland.windowManager.sway.extraConfig = ''
    exec obs --startreplaybuffer --disable-shutdown-check --minimize-to-tray
  '';

  wayland.windowManager.sway.config.output = {
    "DP-3" = {
      mode = "1920x1080@165Hz";
      position = "1920 0";
      # allow_tearing = "yes";
      bg = "${inputs.wallpaper.outPath} fill";
    };
    "HDMI-A-1" = {
      position = "0 0";
    };
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  home.sessionVariables.DEFAULT_BROWSER = lib.getExe pkgs.firefox;

  services = {
    udiskie.enable = true;
  };
  programs = {
    starship.enable = true;
    zoxide.enable = true;
    lazygit.enable = true;
    distrobox.enable = true;
  };
  home.packages = with pkgs; [
    # coding
    tokei
    devenv
    lazyjj
    jjui
    vscodium-fhs
    android-studio
    jetbrains.rider
    jetbrains.idea-ultimate

    # communication
    element-desktop

    # audio
    pwvucontrol
    qpwgraph

    # productivity
    tdf # terminal pdf reader
    obsidian

    # passwords
    keepassxc
    bitwarden-desktop

    # creating
    krita
    blender
    godot
    libreoffice-qt6

    # system things
    kdePackages.dolphin

    # music
    puddletag
    picard

    # media
    stremio
    feishin
    foliate

    # games
    heroic
    lutris
    ryubing # switch emu
    prismlauncher
    inputs.sobercookie.packages.${pkgs.system}.default
    self.packages.${pkgs.system}.krunker
  ];
}
