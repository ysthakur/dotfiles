# Configuration stuff

## Miscellaneous

- [asdf](https://asdf-vm.com) - For managing different versions of Node and other stuff
- Install Python `sh` module to do shell stuff from Python
  - Drop into `python` repl and use like a shell, but with Python syntax

## Prompt

Uses [Oh My Posh](https://ohmyposh.dev/) for the prompt. The configuration file lives in
[github.com/ysthakur/shared-config](https://github.com/ysthakur/shared-config/blob/main/my_prompt_theme.omp.json),
but chezmoi copies it to `~/my_prompt_theme.omp.json` because it's listed in [`.chezmoiexternal.toml`](./.chezmoiexternal.toml).

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

### Background images

`.background-image` is automatically used as the desktop wallpaper by NixOS.
`screensaver.png` is set up to be used as the screensaver (user-specific config).
