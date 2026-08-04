{
  programs.chromium = {
    enable = true;
    # package = pkgs.ungoogled-chromium;
    extensions = [
      {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # ublock origin lite
    ];
  };
}
