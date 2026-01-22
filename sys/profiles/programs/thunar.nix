{pkgs, ...}: {
  services.tumbler.enable = true; # image thumbnails
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
    ];
  };
}
