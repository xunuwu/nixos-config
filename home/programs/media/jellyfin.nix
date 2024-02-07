{pkgs, ...}: {
  home.packages = with pkgs; [
    jellyfin-media-player
    jellycli
  ];
}
