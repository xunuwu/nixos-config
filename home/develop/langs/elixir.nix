{pkgs, ...}: {
  home.packages = with pkgs; [
    beamPackages.elixir_1_18
  ];
}
