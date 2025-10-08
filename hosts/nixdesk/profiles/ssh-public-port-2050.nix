{pkgs, ...}: {
  systemd.services.ssh-port2050-natpmp = {
    bindsTo = ["sshd.socket"];
    after = ["sshd.socket"];
    serviceConfig.Restart = "on-failure";
    serviceConfig.ExecStart = pkgs.writeScript "ssh-port2050-natpmp" ''
      #!${pkgs.bash}/bin/bash

      while true
      do
        ${pkgs.libnatpmp}/bin/natpmpc -a 2050 22 tcp 60
        ${pkgs.coreutils}/bin/sleep 30
      done
    '';
  };
}
