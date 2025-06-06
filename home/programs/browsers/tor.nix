{pkgs, ...}: {
  home.packages = with pkgs; [
    (tor-browser.override {
      mediaSupport = false;
    })
  ];
}
