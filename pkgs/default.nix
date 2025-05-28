{pkgs, ...}: {
  packages = {
    jdnbtexplorer = pkgs.qt6Packages.callPackage ./jdnbtexplorer {};
    binaryninja-personal = pkgs.qt6Packages.callPackage ./binaryninja-personal {};
    krunker = pkgs.callPackage ./krunker {};
    ida-pro = pkgs.callPackage ./ida-pro {};
    cartograph-cf = pkgs.callPackage ./cartograph-cf {};
  };
}
