{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default];
  home.sessionVariables.EDITOR = "nvim";
}
