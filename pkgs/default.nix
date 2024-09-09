{pkgs, ...}: let
  nv_generated = pkgs.callPackage ../_sources/generated.nix {};
in {
  jdnbtexplorer = pkgs.qt6Packages.callPackage ./jdnbtexplorer {};
  gamesand = pkgs.callPackage ./gamesand {};
  pince = pkgs.callPackage ./pince {};
  binaryninja-personal = pkgs.qt6Packages.callPackage ./binaryninja-personal {};
  sobercookie = pkgs.callPackage ./sobercookie {inherit nv_generated;};
  krunker = pkgs.callPackage ./krunker {inherit nv_generated;};
}
