{inputs, ...}: {
  imports = [
    inputs.small-nvim.homeManagerModules.small-nvim
    ../../terminal/shell/zsh.nix
    ../../terminal/programs
    ../../terminal/programs/lazygit.nix
    ../../develop
    ../../develop/small-misc.nix
  ];

  xun.small-nvim = {
    enable = true;
    colorscheme = {
      name = "dayfox";
      package = "EdenEast/nightfox.nvim";
    };
    wakatime.enable = false;
  };
}
