{lib, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    # https://wiki.archlinux.org/title/PipeWire#Noticeable_audio_delay_or_audible_pop/crack_when_starting_playback
    wireplumber.extraConfig."51-disable-suspension.conf" = {
      "monitor.alsa.rules" = lib.singleton {
        matches = [
          {"node.name" = "~alsa_input.*";}
          {"node.name" = "~alsa_output.*";}
        ];
        actions.update-props."session.suspend-timeout.seconds" = 0;
      };
      "monitor.bluez.rules" = lib.singleton {
        matches = [
          {"node.name" = "~bluez_input.*";}
          {"node.name" = "~bluez_output.*";}
        ];
        actions.update-props."session.suspend-timeout-seconds" = 0;
      };
    };
  };
}
