{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.xun.gaming;
in {
  options.xun.gaming = {
    enable = lib.mkEnableOption "gaming";
    steam.enable = lib.mkEnableOption "steam";
    gamemode.enable = lib.mkEnableOption "gamemode";
    gamescope.enable = lib.mkEnableOption "gamescope";
  };

  config = lib.mkIf cfg.enable ({
      programs.gamescope = lib.mkIf cfg.gamescope.enable {
        enable = true;
        capSysNice = false; # doesnt work with steam & heroic
      };
      programs.gamemode.enable = cfg.gamemode.enable;
    }
    // lib.mkIf cfg.steam.enable {
      # TODO: protontricks & steamtinkerlaunch
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
        ## Fixes gamescope (NOTE: no clue what this means)
        extraPackages = with pkgs; [
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
        ];
      };
    });
}
