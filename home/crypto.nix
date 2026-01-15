{ config, lib, pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
    keybase
    monero-gui
    eigenwallet
  ];

  # TODO: only if chromium is enabled
  programs.chromium = {
    extensions = [
      "gafhhkghbfjjkeiendhlofajokpaflmk" # Lace wallet
      "bfnaelmomeimhlpmgjnjophhpkkoljpa" # Phantom wallet
      "aholpfdialjgjfhomihkjbmgjidlcdno" # Exodus wallet
    ];
  };
}
