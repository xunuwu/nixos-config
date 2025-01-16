{pkgs, ...}: {
  home.packages = with pkgs; [
    cmake
    clang
    gnumake
    ninja
    pkg-config
  ];
}
