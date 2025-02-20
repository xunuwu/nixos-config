{
  config,
  inputs,
  ...
}: {
  imports = [inputs.vpn-confinement.nixosModules.default];

  # networking.wg-quick.interfaces."wireguard".configFile = config.sops.secrets.wireguard.path;

  vpnNamespaces."wg" = {
    enable = true;
    wireguardConfigFile = config.sops.secrets.wireguard.path;
    accessibleFrom = ["192.168.0.0/24"];

    # Forwarded to my vpn, for making things accessible from outside
    openVPNPorts = [
      {
        port = 26449;
        protocol = "both";
      }
      {
        port = 26450;
        protocol = "both";
      }
    ];

    # From inside of the vpn namespace to outside of it, for making things inside accessible to LAN
    portMappings = [];
  };
}
