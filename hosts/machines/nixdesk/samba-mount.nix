{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.cifs-utils];
  systemd.mounts = [
    {
      description = "smb hopper transmission download directory";
      what = "//192.168.50.97/transmission"; # hopper local ip
      where = "/server/transmission";
      type = "cifs";
      options = "uid=xun,gid=users,credentials=${config.sops.secrets.samba.path}";
    }
    {
      description = "smb hopper vault";
      what = "//192.168.50.97/vault"; # hopper local ip
      where = "/server/vault";
      type = "cifs";
      options = "uid=xun,gid=users,credentials=${config.sops.secrets.samba.path}";
    }
    {
      description = "smb hopper library";
      what = "//192.168.50.97/library"; # hopper local ip
      where = "/server/library";
      type = "cifs";
      options = "uid=xun,gid=users,credentials=${config.sops.secrets.samba.path},vers=3.0";
    }
    {
      description = "smb hopper slskd files";
      what = "//192.168.50.97/slskd"; # hopper local ip
      where = "/server/slskd";
      type = "cifs";
      options = "uid=xun,gid=users,credentials=${config.sops.secrets.samba.path}";
    }
  ];

  systemd.automounts = [
    {
      requires = ["network-online.target"];
      where = "/server/transmission";
      wantedBy = ["multi-user.target"];
      automountConfig = {
        TimeoutIdleSec = "10min";
      };
    }
    {
      requires = ["network-online.target"];
      where = "/server/vault";
      wantedBy = ["multi-user.target"];
      automountConfig = {
        TimeoutIdleSec = "10min";
      };
    }
    {
      requires = ["network-online.target"];
      where = "/server/library";
      wantedBy = ["multi-user.target"];
      automountConfig = {
        TimeoutIdleSec = "10min";
      };
    }
    {
      requires = ["network-online.target"];
      where = "/server/slskd";
      wantedBy = ["multi-user.target"];
      automountConfig = {
        TimeoutIdleSec = "10min";
      };
    }
  ];
}
