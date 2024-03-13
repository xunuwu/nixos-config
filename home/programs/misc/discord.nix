{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
    (discord.override {
      withVencord = true;
      withOpenASAR = true;
    })
  ];
}
