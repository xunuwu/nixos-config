{pkgs, ...}: {
  home.packages = with pkgs; [
    # TODO: remove this once the vesktop screenshare update gets released
    (vesktop.overrideAttrs (final: prev: {
      version = "ab9e8579eea046187c5cdb51e2041a0beb6e8601";
      src = pkgs.fetchgit {
        url = "https://github.com/Vencord/Vesktop.git";
        rev = "ab9e8579eea046187c5cdb51e2041a0beb6e8601";
        hash = "sha256-s3ndHHN8mqbzL40hMDXXDl+VV9pOk4XfnaVCaQvFFsg=";
      };
      pnpmDeps = prev.pnpmDeps.overrideAttrs {
        outputHash = "sha256-6ezEBeYmK5va3gCh00YnJzZ77V/Ql7A3l/+csohkz68=";
      };
    }))
    (discord.override {
      withVencord = true;
      withOpenASAR = true;
    })
  ];
}
