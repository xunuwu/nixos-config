{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    extraPackages = _:
      with pkgs; [
        graphviz # org-roam graph
      ];
  };

  home.packages = with pkgs; [
    cmake
    gnumake
    gcc
    gdb
    libtool
  ];

  services.emacs = {
    enable = true;
  };
}
