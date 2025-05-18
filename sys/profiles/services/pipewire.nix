{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    extraConfig = let
      rate = 48000;
      min-quantum = 512;
      max-quantum = 1024;
    in {
      pipewire."92-quantum"."context.properties" = {
        "default.clock.rate" = rate;
        "default.clock.quantum" = min-quantum;
        "default.clock.min-quantum" = min-quantum;
        "default.clock.max-quantum" = max-quantum;
      };

      pipewire-pulse."92-quantum" = let
        qr = "${toString min-quantum}/${toString rate}";
      in {
        "context.properties" = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {};
          }
        ];
        "pulse.properties" = {
          "pulse.default.req" = qr;
          "pulse.min.req" = qr;
          "pulse.max.req" = qr;
          "pulse.min.quantum" = qr;
          "pulse.max.quantum" = qr;
        };
        "stream.properties" = {
          "node.latency" = qr;
        };
      };
    };
  };
}
