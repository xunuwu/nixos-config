{
  self,
  inputs,
  homeImports,
  ...
}: let
  specialArgs = {
    inherit inputs self;
  };
in {
  flake.colmena = let
    mod = "${self}/system";
    inherit (import "${self}/system") desktop;
  in {
    meta = {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      inherit specialArgs;
    };
    nixdesk = {
      deployment = {
        allowLocalDeployment = true;
        targetHost = null;
      };
      imports =
        desktop
        ++ [
          ./nixdesk

          "${self}/secrets"
          "${self}/secrets/nixdesk"

          "${mod}/services/syncthing.nix"
          "${mod}/desktop/x11/nosleep.nix"

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
      };
      imports = [
        ./hopper

        "${self}/secrets"
        "${self}/secrets/hopper"

        "${mod}/core"

        "${mod}/programs/home-manager.nix"

        "${mod}/desktop"
        "${mod}/desktop/awesome.nix"

        "${mod}/hardware/opengl.nix"
        "${mod}/hardware/steam-hardware.nix"
        "${mod}/hardware/bluetooth.nix"
        "${mod}/hardware/qmk.nix"

        "${mod}/network/avahi.nix"
        "${mod}/network/networkd.nix"
        "${mod}/network/tailscale.nix"

        "${mod}/services"
        "${mod}/services/pipewire.nix"
        "${mod}/services/syncthing.nix"
        "${mod}/services/containers/server"

        #"${mod}/services/networkd-wireguard.nix"
        #"${mod}/services/wireguard.nix"
        #"${mod}/services/transmission.nix"

        {
          home-manager = {
            users.xun.imports = homeImports."xun@hopper";
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };
    liveiso = {
      deployment.targetHost = null;
      imports = [
        ./liveiso

        "${mod}/nix"
        "${mod}/core/security.nix"

        "${mod}/services"

        "${mod}/desktop"
      ];
    };
  };
  flake.nixosConfigurations = let
    l = inputs.nixpkgs.lib;
  in (builtins.mapAttrs (n: v:
    l.nixosSystem {
      inherit specialArgs;
      modules = v.imports;
    }) (l.filterAttrs (n: _: n != "meta") self.colmena));
}
