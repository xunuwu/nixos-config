{
  pkgs,
  vars,
  ...
}: {
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

    openssh.authorizedKeys.keys = with vars.sshKeys; [
      xun_nixdesk
      xun_redmi
      deck_steamdeck
    ];
  };
}
