{
  pkgs,
  inputs,
  ...
}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        LD_AUDIT = "${
          inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
        }/library-inject.so:${
          inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
        }/SLSsteam.so";
      };
    };
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    ## Fixes gamescope (NOTE: no clue what this means)
    extraPackages = with pkgs; [
      libXcursor
      libxi
      libxinerama
      libxscrnsaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
      webkitgtk_6_0
    ];
  };
}
