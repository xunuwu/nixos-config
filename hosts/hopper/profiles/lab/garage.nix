{
  pkgs,
  vars,
  config,
  ...
}: {
  services.garage = {
    enable = true;
    package = pkgs.garage_1_2_0;
    settings = {
      replication_factor = 1;

      rpc_bind_addr = "[::]:8005";
      rpc_secret = "4425f5c26c5e11581d3223904324dcb5b5d5dfb14e5e7f35e38c595424f5f1e6";

      s3_api = {
        api_bind_addr = "/run/garage/s3.sock";
        s3_region = "garage";
        root_domain = "s3.${vars.domain}";
      };

      s3_web = {
        bind_addr = "/run/garage/web.sock";
        root_domain = ".s3-web.hopper.priv.${vars.domain}";
      };
    };
  };

  systemd.services.garage.serviceConfig.RuntimeDirectory = "garage";
}
