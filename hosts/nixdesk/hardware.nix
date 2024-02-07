{pkgs, ...}: {
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
      device = "/dev/disk/by-uuid/0c080ce8-26f0-454b-a100-1ca9d5308931";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D23A-89BF";
      fsType = "vfat";
    };
  };

  hardware.enableAllFirmware = true;

  services.xserver.videoDrivers = ["amdgpu"];

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
