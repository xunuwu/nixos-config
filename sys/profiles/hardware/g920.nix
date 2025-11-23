{pkgs, ...}: {
  # hardware.usb-modeswitch.enable = true;
  # hardware.xpadneo.enable = true;

  environment.systemPackages = with pkgs; [
    oversteer
  ];

  environment.etc = {
    # Creates /etc/usb_modeswitch.d/046d:c261
    "usb_modeswitch.d/046d:c261" = {
      text = ''
        # Logitech G920 Racing Wheel
        DefaultVendor=046d
        DefaultProduct=c261
        MessageEndpoint=01
        ResponseEndpoint=01
        TargetClass=0x03
        MessageContent="0f00010142"
      '';
    };
  };

  services.udev.extraRules = "ATTR{idVendor}==\"046d\", ATTR{idProduct}==\"c261\", RUN+=\"${pkgs.usb-modeswitch}/bin/usb_modeswitch -c '/etc/usb_modeswitch.d/046d\:c261'\"";
}
