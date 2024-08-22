{
  self,
  inputs,
  homeImports,
  lib,
  pkgs,
  ...
}: let
  specialArgs = {
    inherit inputs self;
  };
  prependAll = a: b: map (x: a + x) b;
  rootPaths = prependAll "${self}/";
  modulePaths = prependAll "${self}/system/";

  inherit (import "${self}/system") desktop;
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
        (modulePaths [
          "core/tools.nix"
          "network/tailscale.nix"

          "programs/tools.nix"

          "nix"
          "nix/gc.nix"
        ])
      ];
    };
    nixdesk = {
      deployment = {
        allowLocalDeployment = true;
        targetUser = "xun";
        targetHost = "nixdesk.local";
      };
      imports =
        desktop
        ++ lib.flatten [
          ./nixdesk

          (rootPaths [
            "secrets"
            "secrets/nixdesk"
          ])

          (modulePaths [
            "services/syncthing.nix"
            "services/virt/waydroid.nix"
            #"services/virt/virt-manager.nix"
            #"network/wifi.nix"
            #"services/ollama.nix"
            "desktop/x11/nosleep.nix"

            "programs/gamemode.nix"
            "programs/gamescope.nix"
            "programs/steam.nix"
            "programs/RE"
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
          "services/containers/experimental"
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
    builtins.mapAttrs (_: v:
      l.nixosSystem {
        inherit specialArgs;
        modules = v.imports;
      }) (l.filterAttrs (n: _: n != "meta") self.colmena);
}
