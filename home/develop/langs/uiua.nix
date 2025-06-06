{pkgs, ...}: {
  home.packages = with pkgs; [
    (uiua.overrideAttrs {buildFeatures = "full";})
    uiua386
  ];
}
