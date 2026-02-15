{ config, lib, pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
    sweethome3d.application
  ];
}
