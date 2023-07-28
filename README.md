# Configuration stuff

## Miscellaneous

- [asdf](https://asdf-vm.com) - For managing different versions of Node and other stuff

## Nix

### Building NixOS configuration

```bash
sudo nixos-rebuild switch
```

NixOS configuration is in `~/nixfiles/configuration.nix`.

### Building Home Manager configuration

```bash
home-manager switch
```

Home Manager configuration is in `~/.config/home-manager`.

### Listing and removing old generations

For NixOS:
```bash
nix-env --list-generations
nix-env --delete-generations <generations>
```

For Home Manager:
```bash
home-manager generations # List generations
home-manager remove-generations <generations>
```

Running the GC:
```bash
nix-store --gc
```

### Removing GRUb entries

(from https://discourse.nixos.org/t/how-to-remove-grub-entries-in-grub-cfg/9059)

```bash
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system # Mark old profiles to be deleted?
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
nix-store --gc # Garbage collect the old profiles
```

