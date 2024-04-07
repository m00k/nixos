let
  pkgs = import <nixpkgs> { config = { }; overlays = [ ]; };
in

pkgs.mkShell {
  packages = with pkgs; [
    nodejs_20
  ];

  MG_NPM_GITHUB_READONLY_TOKEN = import ../.secrets/git.token.mg.npm.nix;

  shellHook = ''
    git status
    node --version
  '';
}
