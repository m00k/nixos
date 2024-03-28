# nixos

## commands

### symlink

```bash
nix-shell -p git

# inside nix-shell:
# clone and link into /etc/nixos
mkdir -p /home/$USER/workspace
cd /home/$USER/workspace
git clone https://github.com/m00k/nixos.git
cd /etc
sudo ln -s /home/$USER/workspace/nixos
cd /home/$USER/workspace/nixos

# build and activate
sudo nixos-rebuild switch - -flake ./#$HOSTNAME
```

OR

copy [install.nix](https://github.com/m00k/nixos/blob/f/multi-host/shells/install.nix) and run

```bash
nix-shell -p install.nix
```

### remove old generations

```bash
nix-env --list-generations --profile /nix/var/nix/profiles/system
nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system # keep last 10 (plus newer than current)
nix-env --delete-generations 30d --profile /nix/var/nix/profiles/system # remove older than 30 days
```

```bash
# use the previous generation
nix-env --rollback --profile /nix/var/nix/profiles/system

# use specific version
nix-env --switch-generations 53 --profile /nix/var/nix/profiles/system # switch to generation no. 53
nix-env --delete-generations 54 --profile /nix/var/nix/profiles/system # delete generation no. 54
```

```bash
# remove old generations from boot menu
nixos-rebuild boot
```

### [bootloader](https://nixos.wiki/wiki/Bootloader)

```bash
# list entries
ll /boot/loader/entries

# UEFI or Legacy boot?
[ -d /sys/firmware/efi/efivars ] && echo "UEFI" || echo "Legacy"
```

### flakes

```bash
nix flakes show # list flake outputs
nixos-rebuild dry-activate --flake ./#hostname # dry run (don't forget to replace _hostname_)
nixos-rebuild dry-build --flake ./#hostname # dry run (don't forget to replace _hostname_)
nixos-rebuild build-vm --flake ./#hostname # build a qemu vm (don't forget to replace _hostname_)
./result/bin/run-username-vm # run vm (don't forget to replace _username_)
```

https://nixos-and-flakes.thiscute.world/nixos-with-flakes/update-the-system

```bash
# Update flake.lock
nix flake update
# Or replace only the specific input, such as home-manager:
nix flake lock --update-input home-manager
# Apply the updates
sudo nixos-rebuild switch --flake .
```

## troubleshooting

### qemu vm

[Impossible to log in](https://discourse.nixos.org/t/impossible-to-log-in-to-result-of-nixos-rebuild-build-vm/9895) to result of `nixos-rebuild build-vm`

> delete the $hostname.qcow2 file if you have started the virtual machine at least once without the right users, otherwise the changes will not get picked up

## resources

- https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
- https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled#switch-to-flake-nix
- https://github.com/NixOS/nixos-hardware/blob/master/README.md#using-nix-flakes-support
