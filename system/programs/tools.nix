{
  pkgs,
  config,
  ...
}: {
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
    fd # find replacement
    (
      if config.nixpkgs.config.allowUnfree
      then p7zip-rar
      else p7zip
    )
    unar
  ];
}
