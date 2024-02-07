{
  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = ["/share/zsh"];

  programs = {
    less.enable = true;

    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = ["main" "brackets" "pattern"];
      };
    };
  };
}
