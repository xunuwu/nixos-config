{
  imports = [
    ./kanshi.nix
    ./defaults.nix

    ../../secrets

    ../../terminal
    ../../terminal/programs/zellij.nix
    ../../terminal/programs/irssi.nix
    ../../terminal/programs/lazygit.nix
    ../../terminal/programs/beets.nix
    ../../editors/nvim.nix
    #../../editors/emacs.nix
    ../../editors/vscode.nix
    ../../programs/browsers/firefox.nix
    ../../programs/browsers/chromium.nix
    ../../terminal/emulator/wezterm.nix
    ../../terminal/emulator/foot.nix

    # desktop
    ../../programs/desktop
    ../../programs/desktop/theme.nix
    ../../programs/desktop/awesome
    #../../programs/desktop/hyprland
    ../../programs/desktop/sway

    # development
    ../../develop

    # programs
    ../../programs/misc/keepassxc.nix
    ../../programs/misc/discord.nix
    ../../programs/misc/ardour.nix
    ../../programs/misc/foliate.nix
    ../../programs/misc/obsidian.nix
    ../../programs/misc/pavucontrol.nix
    ../../programs/misc/thunderbird.nix
    #../../programs/music
    #../../programs/music/yams.nix
    ../../programs/music/spotify.nix
    ../../programs/media
    ../../programs/media/jellyfin.nix
    # gaming
    ../../programs/games
    ../../programs/games/ludusavi.nix

    # media services
    ../../services/media/playerctl.nix
    # system services
    ../../services/system/polkit-agent.nix
    ../../services/system/udiskie.nix
  ];
}
