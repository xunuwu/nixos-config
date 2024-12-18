{
  self,
  super,
  root,
}: {lib, ...}: {
  nix.settings.trusted-users = ["deploy"]; # trust closures created by our user

  users.groups.deploy = {};
  users.users.deploy = {
    isSystemUser = true;
    useDefaultShell = true;
    group = "deploy";
    extraGroups = ["wheel"];

    hashedPassword = lib.mkForce null;
    hashedPasswordFile = lib.mkForce null;
    password = lib.mkForce null;
    passwordFile = lib.mkForce null;

    openssh.authorizedKeys.keys = with root.sshKeys; [
      xun_nixdesk
    ];
  };
}
