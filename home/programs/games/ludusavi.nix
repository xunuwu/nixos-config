{pkgs, ...}: {
  home.packages = with pkgs; [
    ludusavi
    rclone
  ];
}
