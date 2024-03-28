{ config, lib, pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
    exodus
    keybase
    monero-gui
  ];

  # TODO: revisit
  xdg.desktopEntries = {
    exodus = {
      name = "Exodus";
      genericName = "Wallet";
      comment = "Secure, manage, and trade blockchain assets.";
      exec = "./Exodus %u";
      terminal = false;
      categories = [ "Utility" "Network" "Finance" ];
      mimeType = [ "x-scheme-handler/exodus" ];
      type = "Application";
    };
  };
}
