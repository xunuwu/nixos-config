{pkgs, ...}: {
  home.sessionVariables.OBS_VKCAPTURE = "1";
  home.sessionVariables.OBS_VKCAPTURE_QUIET = "1";

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      wlrobs
      obs-vkcapture
    ];
  };
}
