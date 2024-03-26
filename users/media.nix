{ config, lib, myConfig, ... }:

{
  imports = [
    ../home/home.nix
  ];

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
      userName = myConfig.userName;
      userEmail = myConfig.userEmail;
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
}
