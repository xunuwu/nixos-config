{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.gigabyte-b550
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      verbose = false;
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
    kernelModules = ["kvm-amd" "msr"];
    extraModulePackages = with config.boot.kernelPackages; [
      # rtl88xxau-aircrack # usb wifi card
    ];
    loader = {
      timeout = 0;
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
    tmp.cleanOnBoot = true;
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
    "/.swapvol" = {
      device = "/dev/disk/by-uuid/d87276c0-ef9c-422e-b2de-effc1b47c654";
      fsType = "btrfs";
      options = ["subvol=swap" "noatime"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/588B-CB97";
      fsType = "vfat";
    };
  };

  boot.resumeDevice = "/dev/disk/by-uuid/d87276c0-ef9c-422e-b2de-effc1b47c654";
  boot.kernelParams = [
    "nowatchdog"
    # btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
    "resume_offset=326444288"
  ];

  swapDevices = lib.singleton {
    device = "/.swapvol/swapfile";
  };

  hardware.enableRedistributableFirmware = true;

  services.xserver.videoDrivers = ["amdgpu"];

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
