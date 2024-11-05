{
  self,
  pkgs,
  ...
}: {
  imports = [
    self.homeManagerModules.xun
    ./kanshi.nix
    ./defaults.nix

    ../../secrets

    # ../../terminal
    # ../../terminal/programs/zellij.nix
    ../../terminal/programs/zoxide.nix
    # ../../terminal/programs/irssi.nix
    ../../terminal/programs/lazygit.nix
    # ../../terminal/programs/beets.nix
    ../../editors/emacs.nix
    ../../editors/nvim.nix
    ../../editors/vscode.nix
    # ../../editors/jetbrains
    ../../programs/browsers/firefox
    ../../programs/browsers/tor.nix
    ../../programs/browsers/chromium.nix
    ../../terminal/emulator/wezterm.nix
    ../../terminal/emulator/foot.nix

    # desktop
    ../../programs/desktop
    # ../../programs/desktop/theme.nix
    ../../programs/desktop/awesome
    #../../programs/desktop/hyprland
    ../../programs/desktop/sway

    # development
    #../../develop
    #../../develop/small-misc.nix

    # programs
    ../../programs/misc/keepassxc.nix
    ../../programs/misc/discord.nix
    ../../programs/misc/obs.nix
    ../../programs/misc/krita.nix
    #../../programs/misc/ardour.nix
    ../../programs/misc/foliate.nix
    # ../../programs/misc/obsidian.nix
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
    # ../../programs/games/roblox.nix
    # ../../programs/games/krunker.nix
    #../../programs/games/ludusavi.nix

    ./dark.nix

    # media services
    ../../services/media/playerctl.nix
    # system services
    ../../services/system/polkit-agent.nix
    ../../services/system/udiskie.nix # although i dont need this for usb memory, it is quite convenient for flashing qmk
  ];
  xun = let
    enabled = {enable = true;};
  in {
    desktop = {
      xdg = enabled;
    };
    programs.terminal = {
      shell.zsh = enabled;
      direnv = enabled;
      comma = enabled;
      tmux = enabled;
      irssi = enabled;
    };
    develop = {
      enable = true;
      docs = enabled;
      lang = {
        c = enabled;
        csharp = enabled;
        zig = enabled;
        lua = enabled;
      };
    };
    gaming = {
      krunker = enabled;
      umu = enabled;
      roblox.sobercookie = enabled;
    };
    # school.geogebra = enabled;
  };

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
