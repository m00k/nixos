{
  description = "m00k nixos installer";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          packages.default = pkgs.writeScriptBin "install" ''
            flakes_repo="https://github.com/m00k/nixos.git"
            workspace=/home/$USER/workspace

            echo "Installing nix configuration for '$USER@$HOSTNAME' from $flakes_repo"
            echo "Creates $workspace/nixos (delete if exists) and symlinks into /etc/nixos"
            echo "WARNING: this will wipe your current /etc/nixos"
            echo -e "\nContinue? (y/N)\n"
            read -N 1 -s stop
            if [ "$stop" != "y" ]; then
            	echo "exiting without changes"
            	exit 0
            fi

            echo "- creating $workspace and cloning $flakes_repo..."
            rm -rf $workspace/nixos
            mkdir -p $workspace
            cd $workspace
            git clone https://github.com/m00k/nixos.git
            echo "- symlinking into /etc/nixos..."
            cd /etc
            sudo rm -rf /etc/nixos
            echo "symlinking into /etc/nixos"
            sudo ln -sf $workspace/nixos
            cd $workspace/nixos
            echo "- switching to new generation..."
            sudo nixos-rebuild switch --flake $workspace/nixos#$HOSTNAME
            echo -e "\ndone."
          '';
          apps.default = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/install";
          };
        }
      );
}
