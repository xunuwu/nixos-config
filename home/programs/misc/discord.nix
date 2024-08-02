{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
    (discord.override {
      withOpenASAR = true;
    })
  ];
}
