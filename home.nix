/* https://nixos.wiki/wiki/Home_Manager  */
{ config, pkgs, ... }:
let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
	imports = [
		(import "${home-manager}/nixos")
	];

	home-manager.users.m00k = { lib, ... }: {
		# HOME   
		home = {
			stateVersion = "23.11";
			packages = [
				pkgs.xclip
				# pkgs.wl-clipboard-x11
			];
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

			# MICRO
			micro = {
				enable = true;
				settings = {
					tabsize = 2;
					mkparents = true;
				};
			};
			
		}; # END PROGRAMS
	};
}
