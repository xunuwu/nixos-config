{
  pkgs,
  vars,
  ...
}: {
  home.packages = with pkgs; [codeberg-cli];

  # most of these are default except for the url
  xdg.configFile."berg-cli/berg.toml".source = (pkgs.formats.toml {}).generate "berg-config" {
    base_url = "git.${vars.domain}";
    protocol = "https";
    no_color = false;
    editor = "nvim";
    max_width = 80;
  };
}
