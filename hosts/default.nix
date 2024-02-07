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
        ./core
        ./core/boot.nix
      ];
    };
  };
}
