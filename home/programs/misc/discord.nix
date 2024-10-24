{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
    # (discord.override {
    #   withOpenASAR = true;
    # })
  ];
  # services.arrpc.enable = true; # RPC with vesktop (disabled since it uses way more cpu than is reasonable for such a program)
}
