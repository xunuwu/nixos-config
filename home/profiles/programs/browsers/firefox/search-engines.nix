{
  lib,
  pkgs,
  ...
}: {
  programs.firefox.profiles.xun.search = let
    inherit (lib) attrsToList singleton;
  in {
    force = true;
    default = "Brave";
    order = [
      "Brave"
      "Google"
      "DuckDuckGo"
    ];

    engines = let
      mkUrl = x: lib.singleton {template = x;};
    in {
      "Home Manager" = {
        urls = mkUrl "https://home-manager-options.extranix.com?release=master&query={searchTerms}";
        iconUpdateURL = "https://home-manager-options.extranix.com/images/favicon.png";
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
        iconUpdateURL = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@gh"];
      };
      "GitHub Repos" = {
        urls = mkUrl "https://github.com/search?q={searchTerms}";
        iconUpdateURL = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@ghr"];
      };
      "GitHub Nix" = {
        urls = mkUrl "https://github.com/search?type=code&q=lang:nix NOT is:fork {searchTerms}";
        iconUpdateURL = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@ghn"];
      };
      "Brave" = {
        urls = mkUrl "https://search.brave.com/search?q={searchTerms}";
        iconUpdateURL = "https://brave.com/static-assets/images/brave-favicon.png";
        definedAliases = ["@b"];
      };
      "YouTube" = {
        urls = mkUrl "https://www.youtube.com/results?search_query={searchTerms}";
        iconUpdateURL = "https://www.youtube.com/favicon.ico";
        definedAliases = ["@yt"];
      };

      "crates.io" = {
        urls = mkUrl "https://crates.io/search?q={searchTerms}";
        iconUpdateURL = "https://crates.io/favicon.ico";
        definedAliases = ["@cr"];
      };

      "Google".metaData.alias = "@go";
      "DuckDuckGo".metaData.alias = "@ddg";
      "Wikipedia".metaData.alias = "@wiki";
      "Bing".metaData.alias = "@bi";
    };
  };
}
