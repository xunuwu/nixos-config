{lib, ...}: {
  imports = [
    ../../editors/nvim.nix
    ../../terminal/shell/zsh.nix

    ../../programs/media
    ../../programs/media/jellyfin.nix

    ../../services/media/playerctl.nix

    ../../services/system/polkit-agent.nix
    ../../services/system/udiskie.nix
  ];
}
