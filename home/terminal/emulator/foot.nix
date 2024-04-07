{
  pkgs,
  lib,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        include = "${pkgs.foot.themes}/share/foot/themes/moonfly";
        font = "monospace:size=9";
      };
    };
  };
}
