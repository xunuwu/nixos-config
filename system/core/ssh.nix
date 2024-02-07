{lib, ...}: {
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      # Use only public keys
      PasswordAuthentication = lib.mkForce false;
      KbdInteractiveAuthentication = lib.mkForce false;

      # root login is never welcome, except for remote builders
      PermitRootLogin = lib.mkForce "prohibit-password";
    };

    startWhenNeeded = lib.mkDefault true;
    openFirewall = lib.mkDefault false;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
