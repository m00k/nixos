 let
   nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
   pkgs = import nixpkgs { config = {}; overlays = []; };
 in

 pkgs.mkShell {
   packages = with pkgs; [
     nodejs
   ];

   MG_NPM_GITHUB_READONLY_TOKEN = import ../.secrets/git.token.mg.nix
+
+  shellHook = ''
+    git status
+  '';
 }
