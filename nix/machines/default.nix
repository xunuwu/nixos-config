{
  self,
  inputs,
  homeImports,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  specialArgs = {
    inherit inputs self;
  };
in {
  flake.nixosConfigurations = {
    kidney = nixosSystem {
      modules = [
        ./kidney

        ../systemProfiles/core/tools.nix
        ../systemProfiles/core/users.nix
        ../systemProfiles/core/locale.nix

        ../systemProfiles/programs/tools.nix
        ../systemProfiles/programs/zsh.nix
        ../systemProfiles/programs/home-manager.nix
        ../systemProfiles/hardware/graphics.nix

        ../systemProfiles/services/flatpak.nix
        ../systemProfiles/services/xdg-portals.nix

        ../systemProfiles/nix/default.nix
        ../systemProfiles/nix/gc.nix
        {
          home-manager = {
            users.xun.imports = homeImports."xun@kidney";
            extraSpecialArgs = specialArgs;
          };
        }
      ];

      inherit specialArgs;
    };
    nixdesk = nixosSystem {
      modules = [
        ./nixdesk

        inputs.stylix.nixosModules.stylix

        ../systemProfiles/secrets/default.nix
        ../systemProfiles/secrets/nixdesk/default.nix

        ../systemProfiles/core/security.nix
        ../systemProfiles/core/users.nix
        ../systemProfiles/core/ssh.nix
        ../systemProfiles/core/locale.nix
        ../systemProfiles/nix/default.nix
        ../systemProfiles/programs/zsh.nix
        ../systemProfiles/core/tools.nix
        ../systemProfiles/core/compat.nix
        ../systemProfiles/core/boot.nix
        ../systemProfiles/core/docs.nix
        ../systemProfiles/core/gvfs.nix

        ../systemProfiles/nix/gc.nix

        ../systemProfiles/hardware/graphics.nix
        ../systemProfiles/hardware/steam-hardware.nix
        ../systemProfiles/hardware/bluetooth.nix
        ../systemProfiles/hardware/qmk.nix

        ../systemProfiles/network/networkd.nix
        ../systemProfiles/network/avahi.nix
        ../systemProfiles/network/localsend.nix
        ../systemProfiles/network/tailscale.nix
        ../systemProfiles/network/goldberg.nix

        ../systemProfiles/desktop/sway.nix

        ../systemProfiles/programs/dconf.nix
        ../systemProfiles/programs/fonts.nix
        ../systemProfiles/programs/home-manager.nix
        # ../systemProfiles/programs/qt.nix
        ../systemProfiles/programs/adb.nix
        ../systemProfiles/programs/kanidm.nix
        ../systemProfiles/programs/openrgb.nix
        ../systemProfiles/programs/tools.nix
        ../systemProfiles/programs/thunar.nix
        ../systemProfiles/programs/corectrl.nix

        ../systemProfiles/services/default.nix
        ../systemProfiles/services/pipewire.nix
        ../systemProfiles/services/flatpak.nix

        ../systemProfiles/services/syncthing.nix
        ../systemProfiles/services/virt/waydroid.nix
        ../systemProfiles/services/virt/virt-manager.nix
        ../systemProfiles/services/sunshine.nix
        # ../systemProfiles/network/wifi.nix

        ../systemProfiles/themes/dark.nix

        ../systemProfiles/programs/gamemode.nix
        ../systemProfiles/programs/gamescope.nix
        ../systemProfiles/programs/steam.nix
        ../systemProfiles/programs/RE/default.nix

        {
          home-manager = {
            backupFileExtension = "hm-backup";
            users.xun.imports = homeImports."xun@nixdesk";
            extraSpecialArgs = specialArgs;
          };
        }
      ];

      inherit specialArgs;
    };
    hopper = nixosSystem {
      modules = [
        ./hopper

        ../systemProfiles/secrets/default.nix
        ../systemProfiles/secrets/hopper/default.nix

        ../systemProfiles/core/security.nix
        ../systemProfiles/core/locale.nix
        ../systemProfiles/core/tools.nix
        ../systemProfiles/core/ssh.nix
        ../systemProfiles/core/deploy.nix
        ../systemProfiles/nix/default.nix # TODO slim this down

        ../systemProfiles/network/tailscale.nix
        ../systemProfiles/network/avahi.nix
        ../systemProfiles/network/networkd.nix
        # services.syncthing # TODO make syncthing not rely on having "xun" user
      ];

      inherit specialArgs;
    };
  };
}
