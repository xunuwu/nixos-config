{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    busybox
    htop
    wget
    ripgrep
    nethogs
    ffmpeg
  ];
}
