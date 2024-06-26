{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require'wezterm'
      local c = {}
      if wezterm.config_builder then
        c = wezterm.config_builder()
      end
      c.hide_tab_bar_if_only_one_tab = true
      c.color_scheme = "deep"
      c.window_padding = { left = 10, right = 10, top = 5, bottom = 5 }
      c.window_decorations = 'RESIZE'
      c.window_close_confirmation = "NeverPrompt"
      c.use_fancy_tab_bar = false

      c.font_size = 9
      c.adjust_window_size_when_changing_font_size = true


      -- Keys
      c.leader = { key = 'j', mods = 'CTRL', timeout_milliseconds = 1000 }
      c.keys = {
        {
          key = 'q',
          mods = 'LEADER',
          action = wezterm.action.CloseCurrentPane { confirm = false },
        },
        {
          key = 'f',
          mods = 'LEADER',
          action = wezterm.action.TogglePaneZoomState,
        },
        {
          key = 'h',
          mods = 'LEADER',
          action = wezterm.action.ActivatePaneDirection('Left'),
        },
        {
          key = 'j',
          mods = 'LEADER',
          action = wezterm.action.ActivatePaneDirection('Down'),
        },
        {
          key = 'k',
          mods = 'LEADER',
          action = wezterm.action.ActivatePaneDirection('Up'),
        },
        {
          key = 'l',
          mods = 'LEADER',
          action = wezterm.action.ActivatePaneDirection('Right'),
        },
        {
          key = 'H',
          mods = 'LEADER',
          action = wezterm.action.SplitPane { direction = 'Left' },
        },
        {
          key = 'J',
          mods = 'LEADER',
          action = wezterm.action.SplitPane { direction = 'Down' },
        },
        {
          key = 'K',
          mods = 'LEADER',
          action = wezterm.action.SplitPane { direction = 'Up' },
        },
        {
          key = 'L',
          mods = 'LEADER',
          action = wezterm.action.SplitPane { direction = 'Right' },
        },
        {
          key = 's',
          mods = 'LEADER',
          action = wezterm.action.PaneSelect {
            mode = "Activate"
          },
        },
        {
          key = ';',
          mods = 'LEADER',
          action = wezterm.action.PaneSelect {
            mode = "SwapWithActive"
          },
        },
      }

      return c
    '';
  };
}
