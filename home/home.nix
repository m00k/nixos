{ config, lib, pkgs, myConfig, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = myConfig.userName;
    homeDirectory = "/home/${myConfig.userName}";
    stateVersion = "24.05";
  };
}
