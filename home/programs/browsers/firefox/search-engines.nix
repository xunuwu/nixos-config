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

    engines = {
      "Home Manager" = {
        urls = singleton {
          template = "https://home-manager-options.extranix.com";
          params = attrsToList {
            query = "{searchTerms}";
            release = "master";
          };
        };
        iconUpdateURL = "https://home-manager-options.extranix.com/images/favicon.png";
        definedAliases = ["@hm"];
      };
      "Nix Packages" = {
        urls = singleton {
          template = "https://search.nixos.org/packages";
          params = attrsToList {
            query = "{searchTerms}";
            channel = "unstable";
          };
        };
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@np"];
      };
      "NixOS Options" = {
        urls = singleton {
          template = "https://search.nixos.org/options";
          params = attrsToList {
            query = "{searchTerms}";
            channel = "unstable";
          };
        };
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@no"];
      };
      "GitHub" = {
        urls = singleton {
          template = "https://github.com/search";
          params = attrsToList {
            q = "{searchTerms}";
            type = "code";
          };
        };
        iconUpdateURL = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@gh"];
      };
      "GitHub Repos" = {
        urls = singleton {
          template = "https://github.com/search";
          params = attrsToList {
            q = "{searchTerms}";
            type = "repositories";
          };
        };
        iconUpdateURL = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@ghr"];
      };
      "GitHub Nix" = {
        urls = singleton {
          template = "https://github.com/search";
          params = attrsToList {
            "q" = "lang:nix {searchTerms}";
            "type" = "code";
          };
        };
        iconUpdateURL = "https://github.githubassets.com/favicons/favicon-dark.svg";
        definedAliases = ["@ghn"];
      };
      "Brave" = {
        urls = singleton {
          template = "https://search.brave.com/search";
          params = attrsToList {
            "q" = "{searchTerms}";
          };
        };
        iconUpdateURL = "https://brave.com/static-assets/images/brave-favicon.png";
        definedAliases = ["@b"];
      };

      "Google".metaData.alias = "@go";
      "DuckDuckGo".metaData.alias = "@ddg";
      "Wikipedia".metaData.alias = "@wiki";
      "Bing".metaData.hidden = true;
    };
  };
}
