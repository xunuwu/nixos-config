{pkgs, ...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # include = "${pkgs.foot.themes}/share/foot/themes/modus-operandi";
        # font = "monospace:size=9";
      };
      mouse.hide-when-typing = true;
    };
  };
}
