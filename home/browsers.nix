{ config, lib, pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
    brave
    chromium
    firefox # TODO: phantom wallet
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "gafhhkghbfjjkeiendhlofajokpaflmk" # Lace wallet
    ];
  };
}
