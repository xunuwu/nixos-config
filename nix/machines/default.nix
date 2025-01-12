{
  self,
  inputs,
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
        {
          home-manager = {
            users.xun.imports = [
              ../../home
              ../../home/profiles/kidney
              {home.stateVersion = "24.05";}
            ];
            extraSpecialArgs = specialArgs;
          };
        }
      ];

      inherit specialArgs;
    };
    nixdesk = nixosSystem {
      modules = [
        ./nixdesk
        {
          home-manager = {
            backupFileExtension = "hm-backup";
            users.xun.imports = [
              ../../home
              ../../home/profiles/nixdesk
              inputs.sops-nix.homeManagerModules.sops
              {home.stateVersion = "23.11";}
            ];
            extraSpecialArgs = specialArgs;
          };
        }
      ];

      inherit specialArgs;
    };
    hopper = nixosSystem {
      modules = [./hopper];

      inherit specialArgs;
    };
  };
}
