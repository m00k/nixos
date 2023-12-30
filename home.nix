/* https://nixos.wiki/wiki/Home_Manager  */
{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

   home-manager.users.m00k = {
    /* The home.stateVersion option does not have a default and must be set */
    home = {
      stateVersion = "23.11";
    };
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */

    programs.bash = {
      enable = true;
      shellAliases = {
        la = "ls -lha";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };
    };

    # GIT
    programs.git = {
      enable = true;
      userName = import ./.secrets/git.user.name.nix;
      userEmail = import ./.secrets/git.user.email.nix;
    };
  };
}
