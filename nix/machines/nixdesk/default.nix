{lib, ...}: {
  imports = [
    ./hardware.nix
    ./hibernate-boot.nix
    ./samba-mount.nix
  ];

  networking.hostName = "nixdesk";

  #swapDevices = lib.singleton {
  #  device = "/dev/disk/by-uuid/1dcce4ab-71da-4928-83d5-62b20fd0fddf";
  #};

  #boot.resumeDevice = "/dev/disk/by-uuid/1dcce4ab-71da-4928-83d5-62b20fd0fddf";

  #boot.kernelParams = [
  #  "resume=UUID=1dcce4ab-71da-4928-83d5-62b20fd0fddf"
  #  "resume_offset=3841492992" # fdisk -l
  #];

  nixpkgs.config = {
    rocmSupport = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
        "discord"
        "obsidian"
        "rider"
        "android-studio-stable"
      ];
    android_sdk.accept_license = true;
  };

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
