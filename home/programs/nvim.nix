{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default pkgs.tree-sitter];
  home.sessionVariables.EDITOR = "nvim";
}
