{pkgs, ...}: {
  documentation = {
    dev.enable = true;
    #man.generateCaches = true;
  };
  environment.systemPackages = with pkgs; [
    linux-manual
    man-pages
    man-pages-posix
  ];
}
