_: {pkgs, ...}: {
  users.users.xun = {
    isNormalUser = true;
    initialPassword = "nixos";
    shell = pkgs.zsh;
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
