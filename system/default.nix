let
  desktop = [
    ./core
    ./core/compat.nix
    ./core/boot.nix
    ./core/docs.nix
    ./core/gvfs.nix

    ./hardware/opengl.nix
    ./hardware/steam-hardware.nix
    ./hardware/bluetooth.nix
    ./hardware/qmk.nix

    ./network/networkd.nix
    ./network/avahi.nix
    ./network/localsend.nix
    ./network/tailscale.nix
    ./network/goldberg.nix

    ./desktop
    ./desktop/awesome.nix
    ./desktop/sway.nix
    #./desktop/hyprland.nix

    ./programs
    ./programs/tools.nix

    ./services
    ./services/pipewire.nix
    ./services/flatpak.nix
  ];
in {
  inherit desktop;
}
