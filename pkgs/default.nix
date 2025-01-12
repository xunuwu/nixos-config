{pkgs, ...}: let
  nv_generated = pkgs.callPackage ../_sources/generated.nix {};
in {
  jdnbtexplorer = pkgs.qt6Packages.callPackage ./jdnbtexplorer {};
  gamesand = pkgs.callPackage ./gamesand {};
  binaryninja-personal = pkgs.qt6Packages.callPackage ./binaryninja-personal {};
  krunker = pkgs.callPackage ./krunker {inherit nv_generated;};
  ida-pro = pkgs.callPackage ./ida-pro {};
  cartograph-cf = pkgs.callPackage ./cartograph-cf {};
}
