{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.packages = [
    #inputs.neovim-config.packages.${pkgs.system}.neovim
    inputs.small-nvim.packages.${pkgs.system}.neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
