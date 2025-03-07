{homeProfiles, ...}: {
  imports = with homeProfiles; [
    default

    # editors.emacs
    editors.nvim

    terminal.shell.zsh
    terminal.programs.xdg
    terminal.programs.direnv
    terminal.programs.comma
    terminal.programs.tmux
    terminal.programs.irssi

    develop.langs.nix
    develop.tools
    develop.devenv

    terminal.programs.git
    terminal.programs.github
    terminal.programs.lazygit
  ];
}
