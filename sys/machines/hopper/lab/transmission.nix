{
  pkgs,
  config,
  ...
}: {
  systemd.services.transmission.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    performanceNetParameters = true;
    settings = let
      mbit = 125;
    in {
      speed-limit-up-enabled = true;
      speed-limit-up = 100 * mbit;
      speed-limit-down-enabled = true;
      speed-limit-down = 150 * mbit;
      rpc-authentication-required = true;
      peer-port = 11936;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.\*.\*";
    };
    credentialsFile = config.sops.secrets.transmission.path;
  };
}
