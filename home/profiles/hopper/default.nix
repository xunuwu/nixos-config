{...}: {
  imports = [
    ../../editors/nvim.nix
    ../../terminal/shell/zsh.nix
    ../../terminal/emulator/wezterm.nix

    ../../programs/browsers/firefox.nix

    ../../programs/desktop/awesome
    ../../programs/games/steam.nix

    ../../programs/media
    ../../programs/media/jellyfin.nix

    ../../services/media/playerctl.nix

    ../../services/system/polkit-agent.nix
    ../../services/system/udiskie.nix
  ];
}
