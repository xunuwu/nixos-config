{pkgs, ...}: {
  # services.openssh.ports = [22 2050];
  systemd.services.port2050-natpmp = {
    bindsTo = ["sshd"]; # might not work
    confinement = {
      enable = true;
      mode = "chroot-only";
    };
    serviceConfig.ExecStart = ''
      while true
      do
        ${pkgs.libnatpmp}/bin/natpmpc -a 2050 22 tcp 60
        sleep 30
      done
    '';
  };
}
