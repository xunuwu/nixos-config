{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    htop
    btop
    wget
    ripgrep
    nethogs
    ffmpeg-full
    parted
    busybox
    file
    lm_sensors
    fd # find replacement
    graphviz-nox
    p7zip
    unar
    jq
    openssl # for generating passwords
    yt-dlp
    inotify-tools
    dig
    python3
  ];
}
