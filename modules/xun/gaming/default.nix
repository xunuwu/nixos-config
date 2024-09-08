{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.xun.gaming;
in {
  options.xun.gaming = let
    mkBool = lib.mkOption {type = lib.types.bool;};
  in {
    enable = lib.mkEnableOption "gaming";
    steam.enable = lib.mkEnableOption "steam";
    gamemode.enable = lib.mkEnableOption "gamemode";
    gamescope.enable = lib.mkEnableOption "gamescope";
    sunshine = {
      enable = lib.mkEnableOption "sunshine";
      openFirewall = mkBool;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.gamescope.enable {
      programs.gamescope = {
        enable = true;
        capSysNice = false; # doesnt work with steam & heroic
      };
    })
    (lib.mkIf cfg.sunshine.enable {
      services.sunshine = {
        enable = true;
        capSysAdmin = true;
        openFirewall = cfg.sunshine.openFirewall;
      };
    })
    (lib.mkIf cfg.gamemode.enable {programs.gamemode.enable = true;})
    (lib.mkIf cfg.steam.enable {
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
    })
  ]);
}
