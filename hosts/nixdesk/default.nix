{
  lib,
  pkgs,
  inputs,
  systemProfiles,
  specialArgs,
  ...
}: {
  # imports = with systemProfiles; [
  imports =
    [
      ./hardware.nix
      ./hibernate-boot.nix
      ./samba-mount.nix
      ./wireguard.nix
      ./restic-server.nix
      ./autologin.nix

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
    ++ (map (x: systemProfiles + x) [
      /core/security.nix
      /core/keyring.nix
      /core/users.nix
      /core/ssh.nix
      /core/locale.nix
      /nix
      /programs/zsh.nix
      /programs/fish.nix
      /core/tools.nix
      /core/compat.nix
      /core/boot.nix
      # core.docs
      /core/gvfs.nix

      /nix/gc.nix

      /hardware/graphics.nix
      /hardware/steam-hardware.nix
      /hardware/bluetooth.nix
      /hardware/qmk.nix

      /network/networkd.nix
      /network/avahi.nix
      /network/localsend.nix
      /network/tailscale.nix
      /network/goldberg.nix

      /desktop/sway.nix

      /programs/dconf.nix
      /programs/fonts.nix
      /programs/home-manager.nix
      # programs.qt
      /programs/adb.nix
      /programs/openrgb.nix
      /programs/tools.nix
      /programs/thunar.nix

      /services
      /services/pipewire.nix
      /services/podman.nix
      /services/flatpak.nix

      # services.syncthing
      /services/waydroid.nix
      /services/virt-manager.nix
      /services/sunshine.nix
      /services/locate.nix
      # network.wifi

      /themes/dark.nix

      /programs/gamemode.nix
      /programs/gamescope.nix
      /programs/steam.nix
      /programs/reverse-engineering.nix
    ]);

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

        "stremio-shell"
        "stremio-server"
      ];
    android_sdk.accept_license = true;
  };

  environment.persistence."/persist".enable = false;

  networking.interfaces.eno1.wakeOnLan.enable = true;

  networking.hostName = "nixdesk";
  system.stateVersion = "23.11";
}
