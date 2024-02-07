let
  desktop = [
    ./core
    ./core/boot.nix

    ./hardware/opengl.nix
    ./hardware/bluetooth.nix

    ./network/networkd.nix
    ./network/avahi.nix
    ./network/tailscale.nix

    ./desktop
    ./desktop/awesome.nix

    ./programs

    ./services
    ./services/pipewire.nix
  ];
in {
  inherit desktop;
}
