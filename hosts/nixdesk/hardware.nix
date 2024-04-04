{...}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = ["amdgpu"];
    };
    kernelModules = ["kvm-amd"];
    loader = {
      timeout = 10;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 120;
        editor = false;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/d87276c0-ef9c-422e-b2de-effc1b47c654";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd"];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/d87276c0-ef9c-422e-b2de-effc1b47c654";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/d87276c0-ef9c-422e-b2de-effc1b47c654";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/588B-CB97";
      fsType = "vfat";
    };
  };

  hardware.enableAllFirmware = true;

  services.xserver.videoDrivers = ["amdgpu"];

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
