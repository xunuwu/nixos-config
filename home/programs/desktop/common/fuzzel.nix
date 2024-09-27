{
  lib,
  pkgs,
  config,
  ...
}: let
  colors = {
    dark = {
      background = "#181818ff";
      text = "#a4c6d9ff";
      match = "#ae61b5ff";
      border = "#feafffff";
      selection = "#242424ff";
      selection-text = "#ffffffff";
      selection-match = "#fac1ffff";
    };
    light = {
      background = "#ffffffff";
      text = "#000000ff";
      match = "#a60000ff";
      border = "#000000ff";
      selection = "#bfbfbfff";
      selection-text = "#000000ff";
      selection-match = "#2544bbff";
    };
  };
in {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${lib.getExe pkgs.foot}";
        layer = "overlay";
      };
      colors = colors."${config.xun.desktop.colorscheme}";
    };
  };
}
