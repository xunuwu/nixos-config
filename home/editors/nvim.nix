{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [inputs.nvim-nix.packages.${pkgs.system}.default];
}
