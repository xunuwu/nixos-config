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
    ./wireguard.nix
    ./restic-server.nix
    ./greetd.nix

    inputs.stylix.nixosModules.stylix

    secrets.default
    secrets.nixdesk

    core.security
    core.keyring
    core.users
    core.ssh
    core.locale
    nix.default
    programs.zsh
    programs.fish
    core.tools
    core.compat
    core.boot
    # core.docs
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
    programs.openrgb
    programs.tools
    programs.thunar
    programs.corectrl

    services.default
    services.pipewire
    services.flatpak

    # services.syncthing
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
    # rocmSupport = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "apple_cursor"
        "steam"
        "steam-unwrapped"
        "discord"
        "discord-ptb"
        "obsidian"
        "rider"
        "idea-ultimate"
        "android-studio-stable"

        "stremio-shell"
        "stremio-server"
      ];
    android_sdk.accept_license = true;
  };

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
