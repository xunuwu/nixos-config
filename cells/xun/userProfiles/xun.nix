{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  users = {
    mutableUsers = true;
    users.xun = {
      isNormalUser = true;
      initialPassword = "xun"; # TODO: manage password with sops-nix
      shell = nixpkgs.zsh;
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
  };

  programs.zsh.enable = true;
}
