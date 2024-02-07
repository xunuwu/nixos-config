{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.neovim-config.packages.${pkgs.system}.neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
