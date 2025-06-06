{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
    (discord.override {
      withOpenASAR = true;
    })
    discord-ptb
  ];
  # services.arrpc.enable = true; # RPC with vesktop (has issues with cpu usage sometimes ime)
}
