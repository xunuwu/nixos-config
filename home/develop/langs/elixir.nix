{pkgs, ...}: {
  home.packages = with pkgs; [
    elixir_1_17
  ];
}
