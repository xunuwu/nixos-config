{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    htop
    btop
    vim
  ];
}
