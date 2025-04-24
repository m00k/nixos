{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      allSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      forAllSystems = fn:
        nixpkgs.lib.genAttrs allSystems
          (system: fn { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell { 
          nativeBuildInputs = [
            pkgs.playwright-driver.browsers
          ];
          packages = with pkgs; [
            playwright-driver.browsers
            nodePackages_latest.nodejs
          ];
          # with git.token.mg.npm.sh:
          # export MG_NPM_GITHUB_READONLY_TOKEN=...
          shellHook = ''
            export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
            export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
            source ~/workspace/nixos/.secrets/git.token.mg.npm.sh
            git status
            node --version
          '';
        };
      });
    };
}
