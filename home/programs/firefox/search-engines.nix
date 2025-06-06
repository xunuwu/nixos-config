{
  lib,
  pkgs,
  ...
}: {
  programs.firefox.profiles.xun.search = {
    force = true;
    default = "google";
    order = [
      "google"
      "Brave"
      "ddg"
    ];

    engines = let
      mkUrl = x: lib.singleton {template = x;};
    in {
      "Home Manager" = {
        urls = mkUrl "https://home-manager-options.extranix.com?release=master&query={searchTerms}";
        icon = "https://home-manager-options.extranix.com/images/favicon.png";
        definedAliases = ["@hm"];
      };
      "Nix Packages" = {
        urls = mkUrl "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@np"];
      };
      "NixOS Options" = {
        urls = mkUrl "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@no"];
      };
      "GitHub" = {
        urls = mkUrl "https://github.com/search?type=code&q={searchTerms}";
        icon = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@gh"];
      };
      "GitHub Repos" = {
        urls = mkUrl "https://github.com/search?q={searchTerms}";
        icon = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@ghr"];
      };
      "GitHub Nix" = {
        urls = mkUrl "https://github.com/search?type=code&q=lang:nix NOT is:fork {searchTerms}";
        icon = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@ghn"];
      };
      "nixpkgs github" = {
        urls = mkUrl "https://github.com/search?type=code&q=repo:NixOS/nixpkgs {searchTerms}";
        icon = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@nixpkgs"];
      };
      "Brave" = {
        urls = mkUrl "https://search.brave.com/search?q={searchTerms}";
        icon = "https://brave.com/static-assets/images/brave-favicon.png";
        definedAliases = ["@b"];
      };
      "youtube" = {
        urls = mkUrl "https://www.youtube.com/results?search_query={searchTerms}";
        icon = "https://www.youtube.com/favicon.ico";
        definedAliases = ["@yt"];
      };
      "crates.io" = {
        urls = mkUrl "https://crates.io/search?q={searchTerms}";
        icon = "https://crates.io/favicon.ico";
        definedAliases = ["@cr"];
      };
      "noogle" = {
        urls = mkUrl "https://noogle.dev/q?term={searchTerms}";
        icon = "https://noogle.dev/favicon.png";
        definedAliases = ["@nog"];
      };

      "google".metaData.alias = "@go";
      "ddb".metaData.alias = "@ddg";
      "bing".metaData.alias = "@bi";
    };
  };
}
