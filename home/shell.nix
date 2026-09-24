{ config, lib, pkgs, myConfig, ... }:

{
  programs = {
    bash = {
      enable = true;
      # Aliases are defined system-wide in system/configuration.nix (environment.shellAliases)
    };
  };
}
