{config, ...}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
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
      WORDCHARS= # this makes ^w actually stop on directory delimiters etc
      zstyle ':completion:*'  matcher-list 'm:{a-z}={A-Z}' # Case insensitive completion


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
