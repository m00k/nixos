{ config, lib, pkgs, pkgs-unstable, myConfig, ... }:

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
    codex
    vscode
  ]);


  programs.git = {
    enable = true;
    settings = {
      user.name = myConfig.userName;
      user.email = myConfig.userEmail;
    };
  };
}
