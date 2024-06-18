{
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
}
