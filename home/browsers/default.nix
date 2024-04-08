{ config, lib, pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
    brave
    chromium
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "hdokiejnpimakedhajhdlcegeplioahd" # LastPass
    ];
  };
}
