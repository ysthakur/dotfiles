# Home Manager configuration

I'm using Home Manager for my user-specific config. The system's configuration.nix is in [nixfiles](/nixfiles).

File structure:
- [flake.nix](./flake.nix) is the entry point for this flake.
- The configuration for every laptop is in `$hostname.nix` (e.g. [old-lenovo.nix](old-lenovo.nix) is for the old Lenovo)
- [hostname.nix](./hostname.nix) contains the current laptop's hostname
- Common configuration for WSL is in [wsl.nix](./wsl.nix)

The way it works is, common configuration (packages and environment variables) go in [flake.nix](./flake.nix). Then, to get laptop-specific configuration, it first reads [hostname.nix](./hostname.nix). hostname.nix differs from laptop to laptop - Chezmoi has been set up to put the hostname of the laptop into this file as a string. Once flake.nix gets the hostname `$hostname` from hostname.nix, it then imports `${hostname}.nix` to get the host-specific configuration.

Yes, the hostname.nix thing is kinda dumb. But given that you're reading this, future self, you've clearly forgotten how everything works and couldn't figure it out yourself by looking at my beautiful self-documenting code, so you're in no position to judge.
