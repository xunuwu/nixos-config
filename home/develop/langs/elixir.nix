{pkgs, ...}: {
  home.packages = with pkgs; [
    elixir_1_18
    lexical
  ];
}
