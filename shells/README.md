# Shells

## create flake

Create `flake.nix`, then commit your changes to to avoid the error:

```
error: path '/nix/store/xyz...123-source/shells/my-flake/flake.nix' does not exist
```

Lock the flake using

```bash
nix flake lock
```

and push to GitHub.

## consume flake

Load (or update) the flake's metadata first

```bash
nix flake --refresh metadata github:m00k/nixos?dir=shells/node
# nix flake show github:m00k/nixos?dir=shells/node
```

then use:

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
