{pkgs, ...}: {
  devShells.default = pkgs.mkShell {
    name = "dots";
    packages = with pkgs; [
      alejandra
      git
      just
      home-manager
      sops
      nvfetcher
    ];
  };
}
