{...}: {
  boot = {
    initrd = {
      availableKernelModules = ["ehci_pci" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/1297e638-f2ff-49a2-a362-314ac7eeaabc";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd"];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/1297e638-f2ff-49a2-a362-314ac7eeaabc";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/1297e638-f2ff-49a2-a362-314ac7eeaabc";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/8D4C-2F05";
      fsType = "vfat";
    };
  };
}
