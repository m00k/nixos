{ config, lib, pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
    firefox
  ];
}
