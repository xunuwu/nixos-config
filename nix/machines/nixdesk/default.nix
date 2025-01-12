{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./hibernate-boot.nix
    ./samba-mount.nix

    inputs.stylix.nixosModules.stylix

    ../../systemProfiles/secrets/default.nix
    ../../systemProfiles/secrets/nixdesk/default.nix

    ../../systemProfiles/core/security.nix
    ../../systemProfiles/core/users.nix
    ../../systemProfiles/core/ssh.nix
    ../../systemProfiles/core/locale.nix
    ../../systemProfiles/nix/default.nix
    ../../systemProfiles/programs/zsh.nix
    ../../systemProfiles/core/tools.nix
    ../../systemProfiles/core/compat.nix
    ../../systemProfiles/core/boot.nix
    ../../systemProfiles/core/docs.nix
    ../../systemProfiles/core/gvfs.nix

    ../../systemProfiles/nix/gc.nix

    ../../systemProfiles/hardware/graphics.nix
    ../../systemProfiles/hardware/steam-hardware.nix
    ../../systemProfiles/hardware/bluetooth.nix
    ../../systemProfiles/hardware/qmk.nix

    ../../systemProfiles/network/networkd.nix
    ../../systemProfiles/network/avahi.nix
    ../../systemProfiles/network/localsend.nix
    ../../systemProfiles/network/tailscale.nix
    ../../systemProfiles/network/goldberg.nix

    ../../systemProfiles/desktop/sway.nix

    ../../systemProfiles/programs/dconf.nix
    ../../systemProfiles/programs/fonts.nix
    ../../systemProfiles/programs/home-manager.nix
    # ../../systemProfiles/programs/qt.nix
    ../../systemProfiles/programs/adb.nix
    ../../systemProfiles/programs/kanidm.nix
    ../../systemProfiles/programs/openrgb.nix
    ../../systemProfiles/programs/tools.nix
    ../../systemProfiles/programs/thunar.nix
    ../../systemProfiles/programs/corectrl.nix

    ../../systemProfiles/services/default.nix
    ../../systemProfiles/services/pipewire.nix
    ../../systemProfiles/services/flatpak.nix

    ../../systemProfiles/services/syncthing.nix
    ../../systemProfiles/services/virt/waydroid.nix
    ../../systemProfiles/services/virt/virt-manager.nix
    ../../systemProfiles/services/sunshine.nix
    # ../../systemProfiles/network/wifi.nix

    ../../systemProfiles/themes/dark.nix

    ../../systemProfiles/programs/gamemode.nix
    ../../systemProfiles/programs/gamescope.nix
    ../../systemProfiles/programs/steam.nix
    ../../systemProfiles/programs/RE/default.nix
  ];

  networking.hostName = "nixdesk";

  nixpkgs.config = {
    # rocmSupport = true; # TODO enable once nixpkgs fixes their shit and llvm libc doesnt fail to compile (https://github.com/NixOS/nixpkgs/issues/368672)
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
        "discord"
        "obsidian"
        "rider"
        "android-studio-stable"
      ];
    android_sdk.accept_license = true;
  };

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
