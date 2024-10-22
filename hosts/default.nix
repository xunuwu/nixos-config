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
          "core/users.nix"
          "core/locale.nix"

          "programs/tools.nix"
          "programs/zsh.nix"
          "programs/home-manager.nix"
          "hardware/graphics.nix"

          "services/flatpak.nix"
          "services/xdg-portals.nix"

          "nix"
          "nix/gc.nix"
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

            # "programs/gamemode.nix" # TEMP: TODO
            # "programs/gamescope.nix" # TEMP: TODO
            # "programs/steam.nix" # TEMP: TODO
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
