{
  pkgs,
  config,
  ...
}: {
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }

      audio_output {
        type   "fifo"
        name   "Visualizer feed"
        path   "/tmp/mpd.fifo"
        format "44100:16:2"
      }

      replaygain "track"
    '';
    musicDirectory = config.xdg.userDirs.music;
  };
  home.packages = [pkgs.mpc-cli];
}
