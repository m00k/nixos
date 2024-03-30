{ config, lib, pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
    git
    inkscape
    meld
    vscode
  ];

  programs.git = {
    enable = true;
    userName = myConfig.userName;
    userEmail = myConfig.userEmail;
  };
}
