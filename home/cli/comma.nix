{inputs, ...}: {
  imports = [inputs.nix-index-database.homeModules.nix-index];

  programs = {
    nix-index-database.comma.enable = true;
    nix-index = {
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };
  };
}
