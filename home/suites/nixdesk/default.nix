{
  self,
  pkgs,
  inputs,
  homeProfiles,
  ...
}: {
  imports = with homeProfiles; [
    ./defaults.nix
    ./outputs.nix

    secrets.default

    default

    terminal.shell.zsh
    terminal.shell.fish

    terminal.programs.xdg
    terminal.programs.direnv
    terminal.programs.tmux
    terminal.programs.comma
    terminal.programs.irssi
    terminal.programs.git
    terminal.programs.github
    terminal.programs.jujutsu

    # editors.emacs
    editors.nvim

    programs.browsers.firefox.default
    programs.browsers.tor
    programs.browsers.chromium

    # terminal.emulator.wezterm
    terminal.emulator.foot

    themes.dark.default

    # desktop
    programs.desktop.default
    programs.desktop.sway.default

    # development
    develop.common
    develop.docs

    develop.langs.haskell
    develop.langs.rust
    develop.langs.elixir
    develop.langs.uiua
    develop.langs.nix
    develop.langs.zig
    develop.langs.lua
    develop.langs.c

    # programs
    programs.misc.discord
    programs.misc.obs

    programs.music.beets
    programs.music.cmus

    programs.media.mpv

    # gaming
    programs.games.default

    services.playerctl
    services.polkit-agent
    # services.appusage
  ];

  services = {
    udiskie.enable = true;
  };
  programs = {
    starship.enable = true;
    zoxide.enable = true;
    lazygit.enable = true;
  };
  home.packages = with pkgs; [
    # coding
    tokei
    devenv
    vscodium
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
    jellyfin-media-player
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
