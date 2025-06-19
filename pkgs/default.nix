{pkgs, ...}: {
  packages = {
    binaryninja-personal = pkgs.qt6Packages.callPackage ./binaryninja-personal {};
    ida-pro = pkgs.callPackage ./ida-pro {};
    cartograph-cf = pkgs.callPackage ./cartograph-cf {};
    keyboard-state = pkgs.callPackage ./keyboard-state {};
  };
}
