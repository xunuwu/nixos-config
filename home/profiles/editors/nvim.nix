{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [inputs.nvim-config.packages.${pkgs.system}.default];
  home.sessionVariables.EDITOR = "nvim";
}
