{
  self,
  lib,
  pkgs,
  inputs,
  homeProfiles,
  ...
}: {
  imports = map (x: homeProfiles + x) [
    /cli/zsh.nix
    /cli/fish.nix

    /cli/xdg.nix
    /cli/direnv.nix
    /cli/tmux.nix
    /cli/comma.nix
    /cli/irssi.nix
    /cli/git.nix
    /cli/github.nix
    /cli/jujutsu.nix

    /programs/nvim.nix

    /programs/firefox/default.nix
    /programs/tor.nix
    /programs/chromium.nix

    /programs/foot.nix

    /themes/dark/default.nix

    # desktop
    /desktop/xdg-portals.nix
    /desktop/sway/default.nix

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
    /programs/discord.nix
    /programs/obs.nix

    /programs/beets.nix
    /programs/cmus.nix

    /programs/mpv.nix

    # gaming
    /programs/mangohud.nix
    /programs/jc141.nix

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

  home = {
    username = "xun";
    homeDirectory = "/home/xun";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  programs.home-manager.enable = true;
}
