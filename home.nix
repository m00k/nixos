/* https://nixos.wiki/wiki/Home_Manager  */
{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.m00k = {
    # HOME   
    home = {
      stateVersion = "23.11";
    };

    #DCONF
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
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
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
        };
      };
      
	  # GIT
	  git = {
	    enable = true;
	    userName = import ./.secrets/git.user.name.nix;
	    userEmail = import ./.secrets/git.user.email.nix;
	  };
	};
  };
}
