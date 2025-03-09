{pkgs, ...}: {
  users.users.xun = {
    isNormalUser = true;
    initialPassword = "nixos";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "input"
      "kvm"
      "libvirt"
      "video"
      "render"
      "audio"
    ];
  };
}
