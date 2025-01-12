{
  inputs,
  self,
  ...
}: {
  imports = [
    ../../editors/emacs.nix
    ../../editors/nvim.nix

    ../../terminal/shell/zsh.nix
    ../../terminal/programs/xdg.nix
    ../../terminal/programs/direnv.nix
    ../../terminal/programs/comma.nix
    ../../terminal/programs/tmux.nix
    ../../terminal/programs/irssi.nix

    ../../develop/langs/nix.nix
    ../../develop/tools.nix
    ../../develop/devenv.nix

    ../../terminal/programs/git.nix
    ../../terminal/programs/github.nix
    ../../terminal/programs/lazygit.nix
  ];
}
