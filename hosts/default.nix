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
  prependAll = a: b: map (x: a + x) b;
  rootPaths = prependAll "${self}/";
  modulePaths = prependAll "${self}/system/";

  profiles = inputs.haumea.lib.load {
    inputs = {inherit inputs lib;};
    src = "${self}/profiles";
  };
in {
  flake.colmena = {
    meta = {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      nodeNixpkgs = {
        nixdesk = import inputs.nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            rocmSupport = true;
          };
        };
      };

      inherit specialArgs;
    };
    kidney = {
      deployment = {
        allowLocalDeployment = true;
      };
      imports = lib.flatten [
        ./kidney
        (with profiles; [
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

        (rootPaths [
          "secrets"
          "secrets/nixdesk"
        ])

        (with profiles; [
          core.default
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

          desktop.default
          desktop.awesome
          desktop.sway
          #..desktop.hyprland

          programs.default
          programs.tools

          services.default
          services.pipewire
          services.flatpak

          services.syncthing
          services.virt.waydroid
          #services.virt.virt-manager
          #network.wifi
          #services.ollama
          desktop.x11.nosleep

          # programs.gamemode # TEMP: TODO
          # programs.gamescope # TEMP: TODO
          # programs.steam # TEMP: TODO
          programs.RE.default
        ])

        {
          home-manager = {
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

        (rootPaths [
          "secrets"
          "secrets/hopper"
        ])

        (modulePaths [
          "core"
          "core/tools.nix"

          #"programs"
          #"programs/steam.nix"

          #"desktop"
          #"desktop/awesome.nix"

          #"hardware/graphics.nix"
          #"hardware/steam-hardware.nix"
          #"hardware/bluetooth.nix"
          #"hardware/qmk.nix"

          "network/avahi.nix"
          "network/networkd.nix"
          "network/tailscale.nix"

          #"services"
          #"services/pipewire.nix"
          "services/syncthing.nix"
          #"services/containers/server"
          # "services/containers/experimental" # TODO maybe reenable this?? or just abandon it and move fully to systemd network namespace
        ])

        #{
        #  home-manager = {
        #    users.xun.imports = homeImports."xun@hopper";
        #    extraSpecialArgs = specialArgs;
        #  };
        #}
      ];
    };
    liveiso = {
      deployment.targetHost = null;
      imports = lib.flatten [
        ./liveiso

        (modulePaths [
          "/nix"
          "/core/security.nix"
          "/services"
          "/desktop"
        ])
      ];
    };
  };
  flake.nixosConfigurations = let
    l = inputs.nixpkgs.lib;
  in
    ## TODO: make use of nixpkgs.pkgs for per-system pkgs without colmena
    builtins.mapAttrs (_: v:
      l.nixosSystem {
        inherit specialArgs;
        modules = v.imports;
      }) (l.filterAttrs (n: _: n != "meta") self.colmena);
}
