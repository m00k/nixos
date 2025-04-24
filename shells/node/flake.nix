{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; };

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
        "18" = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_18
          ];
          shellHook = shellHook;
        };
        "20" = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_20
          ];
          shellHook = shellHook;
        };
        "22" = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_22
          ];
          shellHook = shellHook;
        };
        "23" = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_23
          ];
          shellHook = shellHook;
        };
        default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_22
          ];
          shellHook = shellHook;
        };
      });
    };
}
