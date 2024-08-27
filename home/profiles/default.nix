{
  self,
  inputs,
  pkgs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};
  homeImports = {
    "xun@kidney" = [
      ../.
      ./kidney
      inputs.nix-index-database.hmModules.nix-index
      {
        programs.nix-index = {
          enableBashIntegration = false;
          enableFishIntegration = false;
          enableZshIntegration = false;
        };
        home.stateVersion = "24.05";
      }
    ];
    "xun@nixdesk" = [
      ../.
      ./nixdesk
      inputs.nix-index-database.hmModules.nix-index
      inputs.sops-nix.homeManagerModules.sops
      inputs.nur.hmModules.nur
      {
        programs.nix-index = {
          enableBashIntegration = false;
          enableFishIntegration = false;
          enableZshIntegration = false;
        };
        home.stateVersion = "23.11";
      }
    ];
    "xun@hopper" = [
      ../.
      ./hopper
      inputs.sops-nix.homeManagerModules.sops
      {home.stateVersion = "23.11";}
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
