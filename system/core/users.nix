{pkgs, ...}: {
  users.users.xun = {
    isNormalUser = true;
    initialPassword = "nixos";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "input"
      "video"
      "render"
      "audio"
    ];
  };
}
