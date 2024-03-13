{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    htop
    btop
    wget
    ripgrep
    nethogs
    ffmpeg
  ];
}
