{ config, lib, pkgs, myConfig, ... }:

{
  imports = [
    ../home/home.nix
    ../home/editor.nix
    ../home/gnome.nix
    ../home/media.nix
    ../home/shell.nix
  ];

  home.packages = with pkgs; [ brave ];
}
