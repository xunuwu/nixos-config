{
  pkgs,
  config,
  vars,
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
      speed-limit-up = 50 * mbit;
      speed-limit-down-enabled = true;
      speed-limit-down = 150 * mbit;
      peer-port = 24003;
      rpc-authentication-required = false;
      rpc-bind-address = "0.0.0.0";
      rpc-host-whitelist = "transmission.hopper.priv.${vars.domain}";
      rpc-whitelist-enabled = true;
      rpc-whitelist = "127.0.0.1,192.168.\*.\*,100.\*.\*.\*";
    };
    # credentialsFile = config.sops.secrets.transmission.path;
  };

  environment.persistence."/persist".directories = ["/var/lib/transmission"];
}
