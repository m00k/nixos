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
     brave
     chromium
     neofetch
     keybase
     exodus
     monero-gui
     gnupg1orig
  ];

  programs.chromium = {
    enable = true;
    extensions = [
    	"eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    	"gafhhkghbfjjkeiendhlofajokpaflmk" # Lace wallet
    ];
  };
}
