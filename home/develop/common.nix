{pkgs, ...}: {
  home.packages = with pkgs; [
    cmake
    meson
    clang
    gnumake
    ninja
    pkg-config
    nodePackages.prettier
  ];
}
