{
  lib,
  self,
  ...
}: {
  nix.settings.trusted-users = ["deploy"]; # trust closures created by our user

  users.groups.deploy = {};
  users.users.deploy = {
    isSystemUser = false;
    isNormalUser = true; # i want a home directory for some things
    useDefaultShell = true;
    group = "deploy";
    extraGroups = ["wheel"];

    hashedPassword = lib.mkForce null;
    hashedPasswordFile = lib.mkForce null;
    password = lib.mkForce null;
    passwordFile = lib.mkForce null;

    openssh.authorizedKeys.keyFiles = [
      (self + /sshKeys/xun_nixdesk)
      (self + /sshKeys/alka_alkpc)
    ];
  };
}
