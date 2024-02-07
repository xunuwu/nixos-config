{
  sops.secrets = {
    tailscale-auth = {
      key = "tailscale-auth";
      sopsFile = ./tailscale-auth.yaml;
    };
  };
}
