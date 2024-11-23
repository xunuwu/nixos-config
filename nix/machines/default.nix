{
  self,
  inputs,
  homeImports,
  lib,
  pkgs,
  config,
  ...
}: let
  specialArgs = {
    inherit inputs self;
  };

  source = inputs.haumea.lib.load {
    inputs = {inherit inputs lib;};
    src = "${self}/nix";
  };
  systemProfiles = source.systemProfiles;
in {
  flake.colmena = {
    meta = {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };

      inherit specialArgs;
    };
    kidney = {
      deployment = {
        allowLocalDeployment = true;
      };
      imports = lib.flatten [
        ./kidney
        (with systemProfiles; [
          core.tools
          core.users
          core.locale

          programs.tools
          programs.zsh
          programs.home-manager
          hardware.graphics

          services.flatpak
          services.xdg-portals

          nix.default
          nix.gc
        ])
        {
          home-manager = {
            users.xun.imports = homeImports."xun@kidney";
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };
    nixdesk = {
      deployment = {
        allowLocalDeployment = true;
        targetUser = "xun";
        targetHost = "nixdesk.local";
      };
      imports = lib.flatten [
        ./nixdesk

        inputs.stylix.nixosModules.stylix

        (with systemProfiles; [
          secrets.default
          secrets.nixdesk.default

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

          desktop.ly
          desktop.awesome
          desktop.sway
          #desktop.hyprland

          programs.dconf
          programs.fonts
          programs.home-manager
          # programs.qt
          programs.adb
          programs.tools
          programs.thunar

          services.default
          services.pipewire
          services.flatpak

          services.syncthing
          services.virt.waydroid
          services.virt.virt-manager
          services.sunshine
          #network.wifi
          #services.ollama
          desktop.x11.nosleep

          themes.dark

          programs.gamemode
          programs.gamescope
          programs.steam
          programs.RE.default
        ])

        {
          home-manager = {
            backupFileExtension = "hm-backup";
            users.xun.imports = homeImports."xun@nixdesk";
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };
    hopper = {
      deployment = {
        targetUser = "xun";
        targetHost = "hopper.local";
      };
      imports = lib.flatten [
        ./hopper

        (with systemProfiles; [
          secrets.default
          secrets.hopper.default

          core.security
          core.locale
          core.tools
          core.ssh
          core.deploy
          nix.default # TODO slim this down

          network.tailscale
          network.avahi
          network.networkd
          # services.syncthing # TODO make syncthing not rely on having "xun" user

          #network.avahi
          #network.networkd
          #network.tailscale

          #services.syncthing
        ])
      ];
    };
    liveiso = {
      deployment.targetHost = null;
      imports = lib.flatten [
        ./liveiso

        (with systemProfiles; [
          nix.default
          core.security
          services.default
        ])
      ];
    };
  };
  flake.nixosConfigurations = let
    l = inputs.nixpkgs.lib;
  in
    builtins.mapAttrs (_: v:
      l.nixosSystem {
        inherit specialArgs;
        modules = v.imports;
      }) (l.filterAttrs (n: _: n != "meta") self.colmena);
}
