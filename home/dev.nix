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
    settings = {
      user.name = myConfig.userName;
      user.email = myConfig.userEmail;
    };
  };
}
