{
  self,
  pkgs,
  homeProfiles,
  ...
}: {
  imports = with homeProfiles; [
    ./defaults.nix

    default

    secrets.default

    terminal.shell.zsh

    terminal.programs.xdg
    terminal.programs.direnv
    terminal.programs.tmux
    terminal.programs.comma
    terminal.programs.zoxide
    terminal.programs.tdf
    terminal.programs.irssi
    terminal.programs.git
    terminal.programs.github
    terminal.programs.lazygit

    editors.emacs
    editors.nvim
    editors.jetbrains.rider
    editors.jetbrains.android-studio

    programs.browsers.firefox.default
    programs.browsers.tor
    programs.browsers.chromium

    terminal.emulator.wezterm
    terminal.emulator.foot

    # desktop
    programs.desktop.default
    programs.desktop.sway.default

    # development
    develop.common
    develop.tools
    develop.docs
    develop.devenv

    develop.langs.haskell
    develop.langs.rust
    develop.langs.uiua
    develop.langs.nix
    develop.langs.zig
    develop.langs.lua
    develop.langs.c

    # programs
    programs.misc.keepassxc
    programs.misc.discord
    programs.misc.element
    programs.misc.obs
    programs.misc.krita
    programs.misc.foliate
    programs.misc.blender
    programs.misc.obsidian
    programs.misc.pwvucontrol
    programs.misc.qpwgraph
    programs.misc.libreoffice
    programs.music.puddletag
    programs.music.picard
    programs.music.cmus
    programs.media.mpv
    programs.media.jellyfin

    # gaming
    programs.games.lutris
    programs.games.heroic
    programs.games.minecraft
    programs.games.roblox
    programs.games.krunker

    services.playerctl
    services.polkit-agent
    services.udiskie # although i dont need this for usb memory, it is quite convenient for flashing qmk
  ];

  qt = {
    enable = true;
    platformTheme = {
      name = "gtk3";
      package = [
        pkgs.libsForQt5.qtstyleplugins
        pkgs.qt6.qtbase
      ];
    };
  };
}
