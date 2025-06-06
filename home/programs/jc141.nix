{pkgs, ...}: {
  home.packages = with pkgs; [
    wineWow64Packages.stagingFull
    bubblewrap
    fuse-overlayfs
    dwarfs
  ];
}
