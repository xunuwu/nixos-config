{
  lib,
  inputs,
  systemProfiles,
  specialArgs,
  self,
  homeSuites,
  ...
}: {
  imports = with systemProfiles; [
    ./hardware.nix
    ./hibernate-boot.nix
    ./samba-mount.nix

    inputs.stylix.nixosModules.stylix

    secrets.default
    secrets.nixdesk

    core.security
    core.users
    core.ssh
    core.locale
    nix.default
    programs.zsh
    core.tools
    core.compat
    core.boot
    core.docs
    core.gvfs

    nix.gc

    hardware.graphics
    hardware.steam-hardware
    hardware.bluetooth
    hardware.qmk

    network.networkd
    network.avahi
    network.localsend
    network.tailscale
    network.goldberg

    desktop.sway

    programs.dconf
    programs.fonts
    programs.home-manager
    # programs.qt
    programs.adb
    programs.kanidm
    programs.openrgb
    programs.tools
    programs.thunar
    programs.corectrl

    services.default
    services.pipewire
    services.flatpak

    services.syncthing
    services.waydroid
    services.virt-manager
    services.sunshine
    # network.wifi

    themes.dark

    programs.gamemode
    programs.gamescope
    programs.steam
    programs.RE

    {
      home-manager = {
        backupFileExtension = "hm-backup";
        users.xun.imports = [
          homeSuites.nixdesk
          inputs.sops-nix.homeManagerModules.sops
          {home.stateVersion = "23.11";}
        ];
        extraSpecialArgs = specialArgs;
      };
    }
  ];

  networking.hostName = "nixdesk";

  nixpkgs.config = {
    rocmSupport = true;
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