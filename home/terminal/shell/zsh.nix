{config, ...}: {
  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "emacs";

    history = {
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh_history";
    };
    initExtra = ''
      unsetopt beep

      ## KEYBINDS ##
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word

      # improve ^w behaviour
      WORDCHARS=

      # shift-tab in completion menu
      bindkey '^[[Z' reverse-menu-complete

      zstyle ':completion:*'  matcher-list 'm:{a-z}={A-Z}' # Case insensitive completion


      ## MISC ##
      setopt extendedglob


      # Show completion categories
      zstyle ':completion:*:*:*:*:descriptions' format '%F{magenta}<-%d->%f'


      ## PROMPT ##
      autoload -Uz vcs_info
      precmd_vcs_info() { vcs_info }
      precmd_functions+=( precmd_vcs_info )
      zstyle ':vcs_info:git:*' formats ' %b '
      setopt prompt_subst

      PROMPT="%F{blue}[%F{magenta}%n%F{blue}@%F{magenta}%M%F{blue}] %~%f %F{green}\$vcs_info_msg_0_%f%(?..%F{red}| %? )%#%f "
    '';
  };
}
