{
  self,
  inputs,
  pkgs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};
  homeImports = {
    "xun@nixdesk" = [
      ../.
      ./nixdesk
      inputs.nix-index-database.hmModules.nix-index
      inputs.sops-nix.homeManagerModules.sops
      {
        programs.nix-index = {
          enableBashIntegration = false;
          enableFishIntegration = false;
          enableZshIntegration = false;
        };
      }
    ];
    "xun@hopper" = [
      ../.
      ./hopper
      inputs.sops-nix.homeManagerModules.sops
    ];
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;
in {
  # we need to pass this to NixOS' HM module
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = {
      "xun@nixdesk" = homeManagerConfiguration {
        modules = homeImports."xun@nixdesk";
        inherit pkgs extraSpecialArgs;
      };
      "xun@hopper" = homeManagerConfiguration {
        modules = homeImports."xun@hopper";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
