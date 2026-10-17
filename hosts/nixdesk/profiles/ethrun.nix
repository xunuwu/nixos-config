{
  pkgs,
  lib,
  ...
}: {
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
       if (
         (action.id === "org.freedesktop.systemd1.manage-units" ||
          action.id.startsWith("org.freedesktop.machine1.")) &&
         subject.isInGroup("wheel")
       ) {
         return polkit.Result.YES;
       }
     });
  '';

  environment.systemPackages = lib.singleton (pkgs.writeShellApplication {
    name = "ethrun";
    runtimeInputs = [pkgs.systemd pkgs.iproute2 pkgs.util-linux pkgs.coreutils];
    text = ''
      # exec sudo -E ip netns exec ethrun-netns sudo -Eu "$USER" "@"

      saved_path=$PATH

      args=(--pipe)
      while IFS= read -r -d "" entry; do
        name=''${entry%%=*}
        [ "$name" = PATH ] && continue
        args+=(--setenv="$name")
      done < /proc/self/environ

      exec run0 "''${args[@]}" -- \
        ip netns exec ethrun-netns runuser -p -u "$USER" -- \
        env "PATH=$saved_path" "$@"
    '';
  });

  systemd.services.ethrun-netns = {
    wantedBy = ["multi-user.target"];
    requires = ["network-online.target"];
    path = [
      pkgs.iproute2
      pkgs.dhcpcd
    ];
    serviceConfig = let
      ns = "ethrun-netns";
      host-if = "eno1";
      mvlan-if = "macvlan0";
    in {
      Type = "oneshot";
      RemainAfterExit = true;

      Restart = "on-failure";
      RestartSec = "15s";

      ExecStart = pkgs.writeShellScript "ethrun-netns-start" ''
        set -euo pipefail

        mkdir -p /etc/netns/${ns}
        cat > /etc/netns/${ns}/resolv.conf <<EOF
        nameserver 1.1.1.1
        nameserver 9.9.9.9
        EOF

        ip link del ${mvlan-if} 2>/dev/null || true
        ip netns delete ${ns} 2>/dev/null || true

        ip netns add ${ns} || true
        ip netns exec ${ns} ip link set lo up

        ip link add ${mvlan-if} link ${host-if} type macvlan mode bridge
        ip link set ${mvlan-if} address 02:23:51:2b:b1:36
        ip link set ${mvlan-if} netns ${ns}
        ip netns exec ${ns} ip link set ${mvlan-if} up

        ip netns exec ${ns} ip addr add 192.168.50.110/24 dev ${mvlan-if}
        ip netns exec ${ns} ip route add default via 192.168.50.1
      '';

      ExecStop = pkgs.writeShellScript "ethrun-netns-stop" ''
        set -euo pipefail

        ip netns delete ${ns} || true
        rm -rf /etc/netns/${ns}
      '';
    };
  };
}
