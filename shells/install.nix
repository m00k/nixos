let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = { }; overlays = [ ]; };
in

pkgs.mkShell {
  packages = with pkgs; [
    git
  ];

  shellHook = ''
    mkdir -p /home/$USER/workspace
    cd /home/$USER/workspace
    git clone https://github.com/m00k/nixos.git
    cd /etc
    sudo ln -s /home/$USER/workspace/nixos
    cd /home/$USER/workspace/nixos
    echo 'done. to build and activate please run:'
    echo 'sudo nixos-rebuild switch - -flake ./#'$HOSTNAME
  '';
}
