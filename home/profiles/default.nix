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
      {home.stateVersion = "24.05";}
    ];
    "xun@nixdesk" = [
      ../.
      ./nixdesk
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
    };
  };
}
