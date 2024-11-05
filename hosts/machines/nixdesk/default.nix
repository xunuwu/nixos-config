{lib, ...}: {
  imports = [
    ./hardware.nix
    ./hibernate-boot.nix
    ./testing.nix
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
        "discord"
        "steam"
        "steam-unwrapped"
      ];
  };

  networking.interfaces.eno1.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
}
