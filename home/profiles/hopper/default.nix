{...}: {
  imports = [
    ../../editors/nvim.nix
    ../../terminal/shell/zsh.nix
    ../../terminal/emulator/wezterm.nix

    ../../programs/browsers/firefox

    ../../programs/desktop
    ../../programs/desktop/awesome

    ../../programs/media
    ../../programs/media/jellyfin.nix

    ../../services/media/playerctl.nix

    ../../services/system/polkit-agent.nix
    ../../services/system/udiskie.nix
  ];
}
