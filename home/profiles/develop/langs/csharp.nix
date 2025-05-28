{pkgs, ...}: {
  home.packages = with pkgs; [
    dotnet-sdk_10
    roslyn-ls
  ];
}
