{config, ...}: {
  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = ["/share/zsh"];

  environment.variables."LESS" = config.programs.less.envVariables.LESS;

  programs = {
    less = {
      enable = true;
      envVariables.LESS = builtins.concatStringsSep " " [
        "--mouse"
        "--RAW-CONTROL-CHARS"
        "--use-color"
      ];
    };

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
