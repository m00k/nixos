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
            echo "Installing nix configuration for '$USER@$HOSTNAME' from $flakes_repo"
            echo "WARNING: this will wipe your current /etc/nixos"
            echo -e "\nContinue? (y/N)\n"
            read -N 1 -s stop
            #echo -e "\n"
            if [ "$stop" != "y" ]; then
            	echo "exiting without changes"
            	exit 0
            fi

            echo "- creating $USER/workspace and cloning $flakes_repo..."
            mkdir -p /home/$USER/workspace
            cd /home/$USER/workspace
            git clone https://github.com/m00k/nixos.git
            echo "- symlinking into /etc/nixos..."
            cd /etc
            echo "symlinking into /etc/nixos"
            sudo ln -s /home/$USER/workspace/nixos
            cd /home/$USER/workspace/nixos
            echo "- switching to new generation..."
            "sudo nixos-rebuild switch - -flake ./#"$HOSTNAME
            echo -e "\ndone."
          '';
          apps.default = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/install";
          };
        }
      );
}
