{ config, lib, pkgs, pkgs-unstable, myConfig, ... }:

{
  home.packages = (with pkgs; [
    git
    inkscape
    meld
  ]) ++ (with pkgs-unstable; [
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
