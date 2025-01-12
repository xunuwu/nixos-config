{pkgs, ...}: {
  services.tumbler.enable = true; # image thumbnails
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };
}
