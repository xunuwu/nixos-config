{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    nixdesk = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./nixdesk
          "${mod}/programs/gamemode.nix"
          "${mod}/services/syncthing.nix"
          "${self}/secrets"
          {
            home-manager = {
              users.xun.imports = homeImports."xun@nixdesk";
              extraSpecialArgs = specialArgs;
            };
          }
        ];
    };
    hopper = nixosSystem {
      inherit specialArgs;
      modules = [
        ./hopper

        "${self}/secrets"

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

        {
          home-manager = {
            users.xun.imports = homeImports."xun@hopper";
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };
  };
}
