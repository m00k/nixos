# Shells

## refresh flakes

```bash
nix flake --refresh metadata github:m00k/nixos?dir=shells/node
# nix flake show github:m00k/nixos?dir=shells/node
```

```bash
cd ~/workspace/projects/private/my-project
# nodejs version: 22
# flake: shells/node/flake.nix
nix develop github:m00k/nixos/?dir=shells/node#22
# branch: f/shells-node
# flake: shells/node/flake.nix
# nix develop github:m00k/nixos/f/shells-node?dir=shells/node
exit
```
