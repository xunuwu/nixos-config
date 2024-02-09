{
  pkgs,
  config,
  ...
}: {
  boot = {
    initrd = {
      systemd.enable = true;
    };

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];

    loader = {
      # systemd-boot on UEFI
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    plymouth.enable = true;
  };

  environment.systemPackages = [
    config.boot.kernelPackages.cpupower
  ];
}
