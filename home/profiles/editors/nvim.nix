{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [inputs.nvim-nix.packages.${pkgs.system}.default];
  home.sessionVariables.EDITOR = "nvim";
}
