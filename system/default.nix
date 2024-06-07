let
  desktop = [
    ./core
    ./core/boot.nix
    ./core/gvfs.nix

    ./hardware/opengl.nix
    ./hardware/steam-hardware.nix
    ./hardware/bluetooth.nix
    ./hardware/qmk.nix

    ./network/networkd.nix
    ./network/avahi.nix
    ./network/localsend.nix
    ./network/tailscale.nix

    ./desktop
    ./desktop/awesome.nix
    ./desktop/sway.nix
    ./desktop/hyprland.nix

    ./programs

    ./services
    ./services/pipewire.nix
    ./services/flatpak.nix
  ];
in {
  inherit desktop;
}
