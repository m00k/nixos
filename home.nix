{ config, lib, ... }:

{

  # HOME
  programs.home-manager.enable = true;
  home = rec {
    username = "m00k";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

  # DCONF
  # https://nixos.org/manual/nixos/stable/#sec-gnome-gsettings-overrides
  # https://nix-community.github.io/home-manager/options.xhtml#opt-dconf.settings
  # https://determinate.systems/posts/declarative-gnome-configuration-with-nixos
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 1800;
      };
      "org/gnome/settings/daemon/plugins/power" = {
        sleep-inactive-ac-timeout = lib.hm.gvariant.mkUint32 1800;
      };
    };
  };

  # PROGRAMS
  programs = {

    # BASH
    bash = {
      enable = true;
      shellAliases = {
        la = "ls -lha";
        ll = "ls -l";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };
    };

    # GIT
    git = {
      enable = true;
      userName = "m00k"; # TODO
      userEmail = "christian.bican@gmail.com"; # TODO
    };

    # MICRO
    micro = {
      enable = true;
      settings = {
        tabsize = 2;
        mkparents = true;
      };
    };

  }; # END PROGRAMS

  # DESKTOP ENTRIES
  xdg.desktopEntries = {
    exodus = {
      name = "Exodus";
      genericName = "Wallet";
      comment = "Secure, manage, and trade blockchain assets.";
      exec = "./Exodus %u";
      terminal = false;
      categories = [ "Utility" "Network" "Finance" ];
      mimeType = [ "x-scheme-handler/exodus" ];
      type = "Application";
    };
  };

}
