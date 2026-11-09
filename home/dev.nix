{ config, lib, pkgs, pkgs-unstable, inputs, myConfig, ... }:

{
  home.packages = (with pkgs; [
    git
    inkscape
    meld
    nodejs_24
    jq
    yq-go # yq
    python3
    fd
    bat
    tree
    gh
  ]) ++ (with pkgs-unstable; [
    vscode
  ]) ++ [
    # pinned, see nixpkgs-codex in flake.nix
    inputs.nixpkgs-codex.legacyPackages.${myConfig.system}.codex
  ];


  programs.git = {
    enable = true;
    settings = {
      user.name = myConfig.userName;
      user.email = myConfig.userEmail;
    };
  };
}
