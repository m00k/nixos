{ config, lib, pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
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
