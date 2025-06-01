{
  services.fail2ban = {
    enable = true;
    ignoreIP = ["100.64.0.0/10"]; # tailscale
    bantime = "1h";
    bantime-increment = {
      enable = true;
      maxtime = "168h";
      factor = "4";
    };
  };
}
