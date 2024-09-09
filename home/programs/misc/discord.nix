{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
    (discord.override {
      withOpenASAR = true;
    })
  ];
  services.arrpc.enable = true; # RPC with vesktop
}
