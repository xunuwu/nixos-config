{
  self,
  lib,
  pkgs,
  inputs,
  homeProfiles,
  ...
}: {
  imports = with homeProfiles; [
    cli.zsh
    cli.fish

    cli.xdg
    cli.direnv
    cli.tmux
    cli.comma
    cli.irssi
    cli.gpg
    cli.git
    cli.github
    cli.forgejo
    cli.jujutsu

    programs.nvim

    programs.firefox.default
    programs.tor
    programs.chromium

    programs.foot

    themes.dark.default

    # desktop
    desktop.xdg-portals
    desktop.sway.default

    # development
    develop.common
    develop.exercism
    develop.docs

    develop.langs.haskell
    develop.langs.go
    develop.langs.js
    develop.langs.rust
    develop.langs.elixir
    develop.langs.python
    develop.langs.nix
    develop.langs.zig
    develop.langs.lua
    develop.langs.c
    develop.langs.csharp
    develop.langs.gleam

    # programs
    programs.discord
    programs.obs

    programs.beets
    programs.cmus

    programs.mpv

    # gaming
    programs.mangohud
    programs.jc141

    services.playerctl
    services.polkit-agent
  ];

  wayland.windowManager.sway.extraConfig = ''
    exec rm -r ~/.config/obs-studio/.sentinel && obs --startreplaybuffer --minimize-to-tray
  '';

  wayland.windowManager.sway.config.input."type:pointer" = {
    accel_profile = "flat";
    pointer_accel = "-0.7";
  };

  wayland.windowManager.sway.config.output = {
    "DP-3" = {
      mode = "1920x1080@165Hz";
      position = "1920 0";
      # allow_tearing = "yes";
      # bg = "${inputs.wallpaper.outPath} fill";
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
    (pkgs.buildFHSEnv {
      name = "silk-fhs";
      runScript = "bash";
      targetPkgs = pkgs: with pkgs; [glfw assimp];
    })
    # jetbrains.idea-ultimate

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
    ddcui

    # music
    puddletag
    picard

    # media
    feishin
    foliate
    kdePackages.okular

    # games
    heroic
    lutris
    ryubing # switch emu
    rpcs3 # ps3 emu
    prismlauncher
    inputs.sobercookie.packages.${pkgs.system}.default
    krunker
    (writeScriptBin "crosshair-overlay" ''
      ${lib.getExe bubblewrap} \
        --ro-bind / / \
        --chdir "$XDG_PICTURES_DIR" \
        -- ${inputs.crosshair-overlay.packages.${pkgs.system}.default}/bin/crosshair-overlay $@
    '')
  ];

  home = {
    username = "xun";
    homeDirectory = "/home/xun";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  programs.home-manager.enable = true;
}
