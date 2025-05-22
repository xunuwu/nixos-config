{pkgs, ...}: {
  home.packages = with pkgs; [
    vtsls
    nodejs
    typescript
    vscode-langservers-extracted
  ];
}
