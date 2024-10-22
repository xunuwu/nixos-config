{config, ...}: {
  systemd.mounts = [
    {
      description = "smb hopper transmission download directory";
      what = "//192.168.50.97/transmission"; # hopper local ip
      where = "/server/transmission";
      type = "cifs";
      options = builtins.readFile ./smbcreds;
    }
    {
      description = "smb hopper vault";
      what = "//192.168.50.97/vault"; # hopper local ip
      where = "/server/vault";
      type = "cifs";
      options = "uid=xun,gid=users," + (builtins.readFile ./smbcreds);
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
  ];
}
