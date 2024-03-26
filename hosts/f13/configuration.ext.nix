{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brave
    chromium
    exodus
    firefox
    git
    gnupg1orig
    inkscape
    keybase
    lf
    meld
    micro
    monero-gui
    neofetch
    nixpkgs-fmt
    ripgrep # rg
    vlc
    vscode
    xclip # wl-clipboard-x11
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "gafhhkghbfjjkeiendhlofajokpaflmk" # Lace wallet
    ];
  };

  # virtualisation
  virtualisation.virtualbox.host.enable = true;
}
