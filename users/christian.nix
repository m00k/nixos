{ config, lib, pkgs, myConfig, ... }:

{
  imports = [
    ../home/home.nix
    ../home/browsers
    ../home/browsers/firefox-vanilla.nix # TODO: make mkOption
    ../home/dev.nix
    ../home/editor.nix
    ../home/gnome.nix
    ../home/shell.nix
  ];
}
