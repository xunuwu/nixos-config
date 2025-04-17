{
  programs.waybar.style = ''
    * {
        font-size: 13px;
    }

    button {
        border: none;
        border-radius: 0;
    }

    #workspaces button {
      padding: 0 5px;
    }

    #workspaces button.urgent {
      box-shadow: inset 0 -3px white;
    }

    #clock {
      padding: 0 10px;
    }

    #workspaces button.visible {
      box-shadow: inset 0 -3px red;
    }
  '';
}
