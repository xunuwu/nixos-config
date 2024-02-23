{
  pkgs,
  inputs,
  ...
}: let
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamescope
        gamemode
        mangohud
      ];
    extraProfile = "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${inputs.nix-gaming.packages.${pkgs.system}.proton-ge}'";
  };
in {
  home.packages = with pkgs; [
    steam-with-pkgs
    steam-run
    steamtinkerlaunch
    protontricks
  ];
}
