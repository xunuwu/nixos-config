{inputs, ...}: {
  imports = [
    inputs.small-nvim.homeManagerModules.small-nvim
    ../../terminal/shell/zsh.nix
    ../../terminal/programs
    ../../terminal/programs/lazygit.nix
    ../../develop
  ];

  xun.small-nvim = {
    enable = true;
    colorscheme = {
      name = "dawnfox";
      package = "EdenEast/nightfox.nvim";
    };
    wakatime.enable = false;
  };
}
