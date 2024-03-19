{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     brave
     chromium
     exodus
     git
     gnupg1orig
     inkscape
     keybase
     meld
     micro
     monero-gui
     neofetch
     vlc
     vscode
  ];

  programs.chromium = {
    enable = true;
    extensions = [
    	"eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    	"gafhhkghbfjjkeiendhlofajokpaflmk" # Lace wallet
    ];
  };
}
