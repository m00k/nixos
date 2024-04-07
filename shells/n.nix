let
  pkgs = import <nixpkgs> { config = { }; overlays = [ ]; };
  # pkgsfixed = import
  #   (fetchTarball {
  #     url = "https://github.com/NixOS/nixpkgs/archive/[SHA].tar.gz";
  #     sha256 = "[SHA]";
  #   })
  #   { };
in

pkgs.mkShell {
  packages = with pkgs; [
    nodejs
  ];

  MG_NPM_GITHUB_READONLY_TOKEN = import ../.secrets/git.token.mg.npm.nix;

  shellHook = ''
    git status
    node --version
  '';
}
