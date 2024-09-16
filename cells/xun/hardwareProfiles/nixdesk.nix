{
  inputs,
  cell,
}: {config, ...}: let
  inherit (inputs) nixpkgs nixos-hardware;
in {
  imports = with nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-pc-ssd
    gigabyte-b550
  ];

  boot = {
    kernelPackages = nixpkgs.linuxPackages_latest;
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
    extraModulePackages = with config.boot.kernelPackages; [
      rtl88xxau-aircrack # usb wifi card
    ];
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
}
