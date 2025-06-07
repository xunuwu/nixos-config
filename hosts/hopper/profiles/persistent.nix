{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/home/desktop"
      "/home/deploy"
      "/media"
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/var/lib/postgresql"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
