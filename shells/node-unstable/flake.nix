{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      allSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      forAllSystems = fn:
        nixpkgs.lib.genAttrs allSystems
          (system: fn { pkgs = import nixpkgs { inherit system; }; });

      # with git.token.mg.npm.sh:
      # export MG_NPM_GITHUB_READONLY_TOKEN=...
      shellHook = ''
        source ~/workspace/nixos/.secrets/git.token.mg.npm.sh
        git status
        node --version
      '';
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nodePackages_latest.nodejs
          ];
          shellHook = shellHook;
        };
      });
    };
}
