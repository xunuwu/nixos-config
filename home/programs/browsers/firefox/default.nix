{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  xdg.configFile."tridactyl/tridactylrc" = {
    text = ''
      unbind <C-e>
      unbind <C-b>
      unbind <C-a> # why would you ever want to increment the current url??
      bind J tabnext
      bind K tabprev

      set smoothscroll true
      set newtab about:blank
      set modeindicator false
    '';
  };
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = with pkgs; [
        tridactyl-native
        keepassxc
      ];
    };
    profiles.xun = {
      extensions = with config.nur.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
        sponsorblock
        tridactyl
        translate-web-pages
        cookie-quick-manager
        istilldontcareaboutcookies
        sidebery
        (lib.mkIf (builtins.elem pkgs.keepassxc config.home.packages) keepassxc-browser)
        (buildFirefoxXpiAddon rec {
          pname = "roseal";
          version = "1.3.44";
          addonId = "{f4f4223a-ff30-4961-b9c0-6a71b7a32aaf}";
          url = "https://addons.mozilla.org/firefox/downloads/file/4323142/roseal-${version}.xpi";
          sha256 = "sha256-Qvd/EUMsSqYCvwUuxjM/ejnn7/TRuhyD82/Azu0dAfE=";
          meta = {};
        })
      ];
      bookmarks = {};
      search = {
        force = true;
        default = "Brave";
        order = [
          "Brave"
          "Google"
          "DuckDuckGo"
        ];
        engines = let
          inherit (lib.attrsets) attrsToList;
          inherit (lib.lists) singleton;
        in {
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
          "Bind".metaData.hidden = true;
        };
      };
      userChrome = builtins.readFile ./userChrome.css;
      settings = {
        "browser.display.use_system_colors" = true; # about:blank colour match colourscheme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # enable userChrome
        "browser.tabs.inTitleBar" = "0"; # use system title bar
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = "about:blank";
        "general.autoScroll" = true; # mmb scroll mode

        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        # Reduce search engine noise in the urlbar's completion window. The
        # shortcuts and suggestions will still work, but Firefox won't clutter
        # its UI with reminders that they exist.
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;

        "browser.download.useDownloadDir" = false;
        "signon.rememberSignons" = false;
        "browser.shell.checkDefaultBrowser" = false;
        # Show whole URL in address bar
        "browser.urlbar.trimURLs" = false;
        # Disable some not so useful functionality.
        "browser.disableResetPrompt" = true; # "Looks like you haven't started Firefox in a while."
        "browser.onboarding.enabled" = false; # "New to Firefox? Let's get started!" tour
        "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "extensions.autoDisableScopes" = "0"; # Automatically enable extensions
        "extensions.pocket.enabled" = true; # i actually use pocket
        "extensions.shield-recipe-client.enabled" = false;
        #"reader.parse-on-load.enabled" = false; # "reader view"

        # disable telemetry
        # https://github.com/hlissner/dotfiles/blob/089f1a9da9018df9e5fc200c2d7bef70f4546026/modules/desktop/browsers/firefox.nix
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "browser.ping-centre.telemetry" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        # Disable crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

        # Disable Form autofill
        # https://wiki.mozilla.org/Firefox/Features/Form_Autofill
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
      };
    };
  };
}
