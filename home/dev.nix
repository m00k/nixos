{ config, lib, pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
    git
    inkscape
    meld
    vscode
    claude-code
    gemini-cli
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = myConfig.userName;
      user.email = myConfig.userEmail;
    };
  };
}
