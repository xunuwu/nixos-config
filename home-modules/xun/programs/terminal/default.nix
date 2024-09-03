{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.xun.programs.terminal;
in {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  options.xun.programs.terminal = {
    direnv.enable = lib.mkEnableOption "direnv";
    comma.enable = lib.mkEnableOption "comma";
    tmux.enable = lib.mkEnableOption "tmux";
    irssi.enable = lib.mkEnableOption "irssi";
    shell.zsh = {
      enable = lib.mkEnableOption "zsh";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.shell.zsh.enable {
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

          # pretty completion menu
          zstyle ':completion:*' menu select

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
    })
    (lib.mkIf cfg.direnv.enable {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    })
    (lib.mkIf cfg.comma.enable {
      programs.nix-index-database.comma.enable = true;
      programs.nix-index = {
        enableBashIntegration = false;
        enableFishIntegration = false;
        enableZshIntegration = false;
      };
    })
    (lib.mkIf cfg.tmux.enable {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        mouse = true;
        escapeTime = 0;
        extraConfig = ''
          bind '"' split-window -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"
          bind c new-window -c "#{pane_current_path}";

          set -g status-style bg=default
          setw -g window-status-current-style fg=#be95ff
          set -g status-justify absolute-centre
          set -g status-interval 5
          set -g status-right "#[fg=#25be6a]#(free -h | awk 'NR==2{print $3\"/\"$2}')"
          set -ag status-right  "#[fg=default] %a %d %b %H:%M"
        '';
      };
    })
    (lib.mkIf cfg.irssi.enable {
      # TODO: make more customizable maybe
      programs.irssi = {
        enable = true;
        networks = {
          liberachat = {
            nick = "wheat";
            server = {
              address = "irc.libera.chat";
              port = 6697;
              autoConnect = true;
            };
            channels = {
              nixos.autoJoin = false;
            };
          };
        };
      };
    })
  ];
}
