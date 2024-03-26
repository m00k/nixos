{ config, lib, myConfig, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = myConfig.userName;
    homeDirectory = "/home/${myConfig.userName}";
    stateVersion = "23.11";
  };
}
