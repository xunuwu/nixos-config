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
      "wireshark"
      "rtkit"
    ];

    openssh.authorizedKeys.keys = with vars.sshKeys; [
      xun_nixdesk
      xun_redmi
      xun_oneplus
      deck_steamdeck
      xun_schoolpc
    ];
  };
}
