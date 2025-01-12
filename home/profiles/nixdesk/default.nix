{
  self,
  pkgs,
  ...
}: {
  imports = [
    ./defaults.nix

    ../../secrets

    ../../terminal/shell/zsh.nix

    ../../terminal/programs/xdg.nix
    ../../terminal/programs/direnv.nix
    ../../terminal/programs/tmux.nix
    ../../terminal/programs/comma.nix
    ../../terminal/programs/zoxide.nix
    ../../terminal/programs/tdf.nix
    ../../terminal/programs/irssi.nix
    ../../terminal/programs/git.nix
    ../../terminal/programs/github.nix
    ../../terminal/programs/lazygit.nix

    ../../editors/emacs.nix
    ../../editors/nvim.nix
    ../../editors/vscode.nix
    ../../editors/jetbrains
    ../../editors/jetbrains/android-studio.nix

    ../../programs/browsers/firefox
    ../../programs/browsers/tor.nix
    ../../programs/browsers/chromium.nix

    ../../terminal/emulator/wezterm.nix
    ../../terminal/emulator/foot.nix

    # desktop
    ../../programs/desktop
    ../../programs/desktop/sway

    # development
    ../../develop/common.nix
    ../../develop/tools.nix
    ../../develop/docs.nix
    ../../develop/devenv.nix

    ../../develop/langs/haskell.nix
    ../../develop/langs/rust.nix
    ../../develop/langs/uiua.nix
    ../../develop/langs/nix.nix
    ../../develop/langs/zig.nix
    ../../develop/langs/lua.nix
    ../../develop/langs/c.nix

    # programs
    ../../programs/misc/keepassxc.nix
    ../../programs/misc/discord.nix
    ../../programs/misc/obs.nix
    ../../programs/misc/krita.nix
    #../../programs/misc/ardour.nix
    ../../programs/misc/foliate.nix
    ../../programs/misc/blender.nix
    ../../programs/misc/obsidian.nix
    ../../programs/misc/pwvucontrol.nix
    ../../programs/misc/qpwgraph.nix
    ../../programs/misc/libreoffice.nix
    # ../../programs/misc/thunderbird.nix
    #../../programs/music
    #../../programs/music/yams.nix
    # ../../programs/music/spotify.nix
    ../../programs/music/puddletag.nix
    ../../programs/music/picard.nix
    ../../programs/music/cmus.nix
    ../../programs/media
    ../../programs/media/jellyfin.nix

    # gaming
    ../../programs/games
    ../../programs/games/roblox.nix
    ../../programs/games/krunker.nix
    #../../programs/games/ludusavi.nix

    # ./dark.nix

    # media services
    ../../services/media/playerctl.nix
    # system services
    ../../services/system/polkit-agent.nix
    ../../services/system/udiskie.nix # although i dont need this for usb memory, it is quite convenient for flashing qmk
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
