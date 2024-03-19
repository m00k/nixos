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

```bash
nix-env --rollback --profile /nix/var/nix/profiles/system
# or explicitly
nix-env --switch-generation 53 --profile /nix/var/nix/profiles/system # switch to generation no. 53
nix-env --delete-generations 54 --profile /nix/var/nix/profiles/system # delete generation no. 54
```

### flakes

```bash
nixos-rebuild dry-activate --flake ./#hostname # dry run (don't forget to replace _hostname_)
nixos-rebuild build-vm --flake ./#hostname # build a qemu vm (don't forget to replace _hostname_)
./result/bin/run-nixos-vm # run
```

## troubleshooting

### qemu vm

[Impossible to log in](https://discourse.nixos.org/t/impossible-to-log-in-to-result-of-nixos-rebuild-build-vm/9895) to result of `nixos-rebuild build-vm`

> delete the $hostname.qcow2 file if you have started the virtual machine at least once without the right users, otherwise the changes will not get picked up

## resources

- https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
- https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled#switch-to-flake-nix
- https://github.com/NixOS/nixos-hardware/blob/master/README.md#using-nix-flakes-support
