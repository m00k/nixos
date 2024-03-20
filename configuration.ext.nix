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
    nixpkgs-fmt
    ripgrep # rg
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

  # virtualisation
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
}
