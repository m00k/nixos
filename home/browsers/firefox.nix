{ config, pkgs, ... }:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs = {
    # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
    firefox = {
      enable = true;
      # https://gitlab.com/kira-bruneau/nixos-config/-/blob/main/home/programs/firefox/default.nix?ref_type=heads
      # profiles = {
      #   search = {
      #     force = true;
      #     default = "DuckDuckGo";
      #     order = [ "DuckDuckGo" "Google" ];
      #     engines = {
      #       "Amazon.ca".metaData.alias = "@a";
      #       "Bing".metaData.hidden = true;
      #       "eBay".metaData.hidden = true;
      #       "Google".metaData.alias = "@g";
      #       "Wikipedia (en)".metaData.alias = "@w";

      #       "GitHub" = {
      #         urls = [{
      #           template = "https://github.com/search";
      #           params = [
      #             { name = "q"; value = "{searchTerms}"; }
      #           ];
      #         }];
      #         icon = "${pkgs.fetchurl {
      #             url = "https://github.githubassets.com/favicons/favicon.svg";
      #             hash = "sha256-apV3zU9/prdb3hAlr4W5ROndE4g3O1XMum6fgKwurmA=";
      #           }}";
      #         definedAliases = [ "@gh" ];
      #       };

      #       "Nix Packages" = {
      #         urls = [{
      #           template = "https://search.nixos.org/packages";
      #           params = [
      #             { name = "channel"; value = "unstable"; }
      #             { name = "query"; value = "{searchTerms}"; }
      #           ];
      #         }];
      #         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #         definedAliases = [ "@np" ];
      #       };

      #       "NixOS Wiki" = {
      #         urls = [{
      #           template = "https://nixos.wiki/index.php";
      #           params = [{ name = "search"; value = "{searchTerms}"; }];
      #         }];
      #         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #         definedAliases = [ "@nw" ];
      #       };

      #       "Nixpkgs Issues" = {
      #         urls = [{
      #           template = "https://github.com/NixOS/nixpkgs/issues";
      #           params = [
      #             { name = "q"; value = "{searchTerms}"; }
      #           ];
      #         }];
      #         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #         definedAliases = [ "@ni" ];
      #       };

      #       # A good way to find genuine discussion
      #       "Reddit" = {
      #         urls = [{
      #           template = "https://www.reddit.com/search";
      #           params = [
      #             { name = "q"; value = "{searchTerms}"; }
      #           ];
      #         }];
      #         icon = "${pkgs.fetchurl {
      #             url = "https://www.redditstatic.com/accountmanager/favicon/favicon-512x512.png";
      #             hash = "sha256-4zWTcHuL1SEKk8KyVFsOKYPbM4rc7WNa9KrGhK4dJyg=";
      #           }}";
      #         definedAliases = [ "@r" ];
      #       };

      #       "Youtube" = {
      #         urls = [{
      #           template = "https://www.youtube.com/results";
      #           params = [{ name = "search_query"; value = "{searchTerms}"; }];
      #         }];
      #         icon = "${pkgs.fetchurl {
      #             url = "https://www.youtube.com/s/desktop/8498231a/img/favicon_144x144.png";
      #             hash = "sha256-lQ5gbLyoWCH7cgoYcy+WlFDjHGbxwB8Xz0G7AZnr9vI=";
      #           }}";
      #         definedAliases = [ "@y" ];
      #       };
      #     };
      #   };
      # };

      # about:policies#documentation
      # https://mozilla.github.io/policy-templates/
      policies = {
        DisableAccounts = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "never"; # "always", "newtab"
        DisplayMenuBar = "default-off"; # "always", "never", "default-on"
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        Homepage = {
          URL = "localhost:8096/"; # jellyfin # TODO: make configurable
        };
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        SearchBar = "unified"; # "separate"

        # about:support
        ExtensionSettings = {
          # blocks all addons except the ones specified below
          "*".installation_mode = "blocked"; # "allowed"
          # Dark Reader
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed"; # "normal_installed"
          };
        };

        # about:config
        Preferences = {
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "browser.formfill.enable" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.translations.neverTranslateLanguages" = [ "de" ];
          "browser.uiCustomization.state" = builtins.toJSON {
            # TODO: set in browser then copy from about:config
            placements = {
              widget-overflow-fixed-list = [ ];
              unified-extensions-area = [ ];
              nav-bar = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "customizableui-special-spring1"
                "urlbar-container"
                "customizableui-special-spring2"
                "downloads-button"
                "fxa-toolbar-menu-button"
                "unified-extensions-button"
                "reset-pbm-toolbar-button"
                "addon_darkreader_org-browser-action"
              ];
              toolbar-menubar = [
                "menubar-items"
              ];
              TabsToolbar = [
                "firefox-view-button"
                "tabbrowser-tabs"
                "new-tab-button"
                "alltabs-button"
              ];
              PersonalToolbar = [
                "import-button"
                "personal-bookmarks"
              ];
            };
            seen = [
              "save-to-pocket-button"
              "developer-button"
              "addon_darkreader_org-browser-action"
            ];
            dirtyAreaCache = [
              "nav-bar"
              "PersonalToolbar"
              "unified-extensions-area"
              "toolbar-menubar"
              "TabsToolbar"
            ];
            currentVersion = 20;
            newElementCount = 2;
          };
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.warnOnQuit" = false;
          "devtools.selfxss.count" = 5; # Allow pasting into console
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
        };
      };
    };
  };
}
