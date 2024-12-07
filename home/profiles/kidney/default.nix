{
  inputs,
  self,
  ...
}: {
  imports = [
    self.homeManagerModules.xun
    ../../editors/emacs.nix
    ../../editors/nvim.nix
    # ../../terminal/shell/zsh.nix
    # ../../terminal/programs
    # ../../terminal/programs/lazygit.nix
    # ../../develop
    # ../../develop/small-misc.nix
  ];

  xun = {
    develop = {
      enable = true;
    };
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
