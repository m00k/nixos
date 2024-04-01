{ config, lib, pkgs, myConfig, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # TODO: https://nix.dev/guides/best-practices.html#with-scopes
  environment.systemPackages = with pkgs; [
    git
    gnupg1orig
    lf
    mktemp
    micro
    neofetch
    nixpkgs-fmt
    ripgrep # rg
    xclip # wl-clipboard-x11
  ];
}
