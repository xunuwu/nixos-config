{pkgs, ...}: {
  jdnbtexplorer = pkgs.qt6Packages.callPackage ./jdnbtexplorer {};
  gamesand = pkgs.callPackage ./gamesand {};
  pince = pkgs.callPackage ./pince {};
  binaryninja-personal = pkgs.qt6Packages.callPackage ./binaryninja-personal {};
  sobercookie = pkgs.callPackage ./sobercookie {};
}
