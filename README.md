# nixos

## commands

### symlink 

```bash
cd ~/workspace
git clone https://github.com/m00k/nixos.git
cd /etc
sudo ln -s /home/[USER]/workspace/nixos
```

### remove old generations
```bash
nix-env --list-generations --profile /nix/var/nix/profiles/system
nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system # keep last 10 (plus newer than current)
nix-env --delete-generations 30d --profile /nix/var/nix/profiles/system # remove older than 30 days
```

## resources
- https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
