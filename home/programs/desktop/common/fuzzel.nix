{
  lib,
  pkgs,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${lib.getExe pkgs.foot}";
        layer = "overlay";
      };
      colors = {
        background = "#181818ff";
        text = "#a4c6d9ff";
        match = "#ae61b5ff";
        border = "#feafffff";
        selection = "#242424ff";
        selection-text = "#ffffffff";
        selection-match = "#fac1ffff";
      };
    };
  };
}
