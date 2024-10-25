{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.protontricks
    pkgs.steamtinkerlaunch
  ];

  programs.steam = {
    enable = true;
    #package = pkgs.steam.overrideAttrs (final: prev: {
    #  nativeBuildInputs = prev.nativeBuildInputs ++ [pkgs.breakpointHook];
    #  postInstall =
    #    prev.postInstall
    #    ++ ''
    #      exit 33
    #    '';
    #});

    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    gamescopeSession.enable = true;
    ## Fixes gamescope
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
}
