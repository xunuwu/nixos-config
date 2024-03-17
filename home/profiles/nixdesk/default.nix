{...}: {
  imports = [
    ../../terminal
    ../../editors/nvim.nix
    ../../editors/emacs.nix
    ../../editors/vscode.nix
    ../../programs/browsers/firefox.nix
    ../../terminal/emulator/wezterm.nix

    # desktop
    ../../programs/desktop/awesome

    # development
    ../../develop

    # programs
    ../../programs/misc/keepassxc.nix
    ../../programs/misc/discord.nix
    ../../programs/misc/thunderbird.nix
    ../../programs/music
    ../../programs/music/yams.nix
    ../../programs/music/spotify.nix
    ../../programs/media
    ../../programs/media/jellyfin.nix
    # gaming
    ../../programs/games
    ../../programs/games/steam.nix

    # media services
    ../../services/media/playerctl.nix
    # system services
    ../../services/system/polkit-agent.nix
    ../../services/system/udiskie.nix
  ];
}
