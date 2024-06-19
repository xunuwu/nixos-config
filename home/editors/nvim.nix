{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.small-nvim.packages.${pkgs.system}.neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
