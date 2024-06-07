{pkgs, ...}: {
  jdnbtexplorer = pkgs.qt6Packages.callPackage ./jdnbtexplorer {};
  gamesand = pkgs.callPackage ./gamesand {};
  pince = pkgs.callPackage ./pince {};
}
