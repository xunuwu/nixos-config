{
  lib,
  pkgs,
  inputs,
  systemProfiles,
  specialArgs,
  ...
}: {
  imports =
    [
      ./hardware.nix
      ./profiles/hibernate-boot.nix
      ./profiles/samba-mount.nix
      ./profiles/wireguard.nix
      ./profiles/restic-server.nix
      ./profiles/autologin.nix

      inputs.impermanence.nixosModules.impermanence
      inputs.stylix.nixosModules.stylix

      {
        home-manager = {
          backupFileExtension = "hm-backup";
          users.xun.imports = [
            ./home.nix
            inputs.sops-nix.homeManagerModules.sops
            {home.stateVersion = "23.11";}
          ];
          extraSpecialArgs = specialArgs;
        };
      }
    ]
    ++ (with systemProfiles; [
      core.security
      core.keyring
      core.users
      core.ssh
      core.locale
      programs.zsh
      programs.fish
      core.tools
      core.compat
      core.boot
      # core.docs
      core.gvfs

      nix.nix
      nix.gc

      hardware.graphics
      hardware.steam-hardware
      hardware.bluetooth
      hardware.qmk
      hardware.g920

      network.networkd
      network.avahi
      network.localsend
      network.tailscale
      network.goldberg
      network.nebula

      desktop.sway

      programs.dconf
      programs.fonts
      programs.home-manager
      # programs.qt
      programs.adb
      programs.gpg
      programs.openrgb
      programs.tools
      programs.thunar
      programs.wireshark

      services.psd
      services.dbus-broker
      services.pipewire
      services.podman
      services.flatpak

      # services.syncthing
      services.waydroid
      services.virt-manager
      services.sunshine
      services.locate
      # network.wifi

      themes.dark

      programs.gamemode
      programs.gamescope
      programs.steam
      programs.reverse-engineering
    ]);

  services.lact.enable = true; # gpu control thing

  services.locate.prunePaths = lib.mkOptionDefault ["/home/xun/backup"];

  # for running waydroid as root, needed for cage-xtmapper
  services.dbus.packages = [
    (pkgs.writeTextDir "/etc/dbus-1/session.d/dbus-allow-root.conf" ''
      <busconfig>
        <policy context="mandatory">
          <allow user="root"/>
        </policy>
      </busconfig>
    '')
  ];

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
        "krunker"
      ];
    android_sdk.accept_license = true;
  };

  environment.persistence."/persist".enable = false;

  networking.interfaces.eno1.wakeOnLan.enable = true;

  networking.hostName = "nixdesk";
  system.stateVersion = "23.11";
}
