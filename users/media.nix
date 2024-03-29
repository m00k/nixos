{ config, lib, pkgs, myConfig, ... }:

{
  imports = [
    ../home/home.nix
    ../home/browsers.nix
    ../home/editor.nix
    ../home/gnome.nix
    ../home/media.nix
    ../home/shell.nix
  ];
}
