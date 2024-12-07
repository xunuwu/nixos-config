_: {pkgs, ...}: {
  services.kanidm = {
    enableClient = true;
    package = pkgs.kanidm_1_4;
    clientSettings.uri = "https://kanidm.xunuwu.xyz";
  };
}
