{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = lib.singleton (pkgs.writeShellApplication {
    name = "ethrun";
    runtimeInputs = [pkgs.iproute2];
    text = ''
      exec sudo -E ip netns exec ethrun-netns sudo -Eu "$USER" "$@"
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

        ip netns add ${ns} || true
        ip netns exec ${ns} ip link set lo up
        ip link add ${mvlan-if} link ${host-if} type macvlan mode bridge
        ip link set ${mvlan-if} netns ${ns}
        ip netns exec ${ns} ip link set ${mvlan-if} up

        sleep 1

        ip netns exec ${ns} dhcpcd
      '';

      ExecStop = pkgs.writeShellScript "ethrun-netns-stop" ''
        set -euo pipefail

        ip netns exec ${ns} pkill -f dhcpcd || true
        ip netns delete ${ns} || true
      '';
    };
  };
}
