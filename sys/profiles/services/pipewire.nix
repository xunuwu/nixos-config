{inputs, ...}: {
  imports = [inputs.nix-gaming.nixosModules.pipewireLowLatency];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    lowLatency.enable = true;
  };
}
