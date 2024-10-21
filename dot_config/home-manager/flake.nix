{
  description = "Home Manager Flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Do NOT use inputs.nixpkgs.follows
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-index-database,
      ghostty,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # Allow unfree packages like Obsidian
        config.allowUnfree = true;
      };
      flakePkgs = {
        # This doesn't work in WSL, so only use in old-lenovo
        ghostty = ghostty.packages.${system}.default;
      };
      util = import ./util.nix {
        inherit
          pkgs
          system
          nixpkgs
          home-manager
          nix-index-database
          ;
      };
      hostname =
        if builtins.pathExists ./hostname.nix then
          import ./hostname.nix
        else
          builtins.abort "No hostname.nix in ~/nixfiles";
      hostSpecific = import ./${hostname}.nix {
        inherit pkgs util flakePkgs;
      };
      username = hostSpecific.username;
      hostSpecificModules = hostSpecific.modules;
    in
    {
      defaultPackage.${system} = home-manager.defaultPackage.${system};

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          nix-index-database.hmModules.nix-index
          {
            programs.home-manager.enable = true;
            programs = {
              java = {
                enable = true;
                package = pkgs.jdk17;
              };

              fzf = {
                enable = true;
                tmux.enableShellIntegration = true;
              };

              neovim = {
                # Only use the config here to install the vim-plug plugin,
                # then use init.vim for the actual config and install the
                # other plugins there using vim-plug
                enable = true;
                plugins = [ pkgs.vimPlugins.vim-plug ];
                # Assumes this file is in ~/.config/home-manager and the
                # Neovim config is in ~/.config/nvim/init.vim
                extraConfig = pkgs.lib.fileContents ./init.vim;
              };

              direnv.enable = true;
              direnv.nix-direnv.enable = true;

              # cat with colors and more
              bat.enable = true;

              # Run commands without installing (uses nix-shell)
              nix-index-database.comma.enable = true;

              # Better than asdf-vm
              mise.enable = true;
            };
            home = {
              username = username;
              homeDirectory = "/home/${username}";
              packages = with pkgs; [
                git
                chezmoi # For managing dotfiles
                ncdu # Show disk usage visually
                nushell
                nu_scripts
                zoxide # cd replacement with extra features
                eza # ls replacement
                oh-my-posh # For fancy prompt
                zellij # Terminal multiplexer (easier to use than tmux)
                helix # Modal editor
                carapace # Completer
                jujutsu # (jj: Git-compatible version control system)
                vivid # To generate LS_COLORS and stuff
                mosh # ssh replacement
                atuin # Also exists as flake
              ];
              sessionVariables = {
                HOSTNAME = hostname;
                EDITOR = "vim";
                BROWSER = "firefox";
                # Use bat to highlight manpages
                MANPAGER = "sh -c 'col -bx | bat -plman'";
                MANROFFOPT = "-c"; # Required for bat to highlight manpages correctly
                # Make less more convenient
                LESS = "--no-init --quit-if-one-screen -R";
              };
              stateVersion = "23.05";
            };
          }
        ] ++ hostSpecificModules;
      };
    };
}
