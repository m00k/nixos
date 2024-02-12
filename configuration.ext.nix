{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     micro
     git
     vscode
     meld
     inkscape
     vlc
     chromium
     neofetch
     keybase
     monero-gui
     gnupg1orig
  ];
}
