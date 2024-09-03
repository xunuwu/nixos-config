{
  inputs,
  self,
  ...
}: {
  imports = [
    self.homeManagerModules.xun
    inputs.small-nvim.homeManagerModules.small-nvim
    # ../../terminal/shell/zsh.nix
    # ../../terminal/programs
    # ../../terminal/programs/lazygit.nix
    # ../../develop
    # ../../develop/small-misc.nix
  ];

  xun = {
    small-nvim = {
      enable = true;
      colorscheme = {
        name = "dayfox";
        package = "EdenEast/nightfox.nvim";
      };
      wakatime.enable = false;
    };
    develop.enable = true;
    desktop = {
      xdg.enable = true;
    };
    programs.terminal = {
      shell.zsh.enable = true;
      direnv.enable = true;
      comma.enable = true;
      tmux.enable = true;
      irssi.enable = true;
    };
  };
}
