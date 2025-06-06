{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.cifs-utils];

  imports = let
    shares = [
      "transmission"
      "vault"
      "library"
      "slskd"
    ];
  in
    map (share: {
      systemd.mounts = lib.singleton {
        description = "smb hopper ${share}";
        what = "//192.168.50.97/${share}";
        where = "/server/${share}";
        type = "cifs";
        options = "uid=xun,gid=users,credentials=${config.sops.secrets.samba.path}";
      };
      systemd.automounts = lib.singleton {
        requires = ["network-online.target"];
        where = "/server/${share}";
        wantedBy = ["multi-user.target"];
        automountConfig = {
          TimeoutIdleSec = "10min";
        };
      };
    })
    shares;
}
