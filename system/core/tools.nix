{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    htop
    btop
    wget
    ripgrep
    nethogs
    ffmpeg
    parted
  ];
}
