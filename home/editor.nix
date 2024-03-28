{ config, lib, pkgs, myConfig, ... }:

{
  programs = {
    micro = {
      enable = true;
      settings = {
        tabsize = 2;
        mkparents = true;
      };
    };
  };
}
