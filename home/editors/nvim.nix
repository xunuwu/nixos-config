{inputs, ...}: {
  imports = [
    inputs.small-nvim.homeManagerModules.small-nvim
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
