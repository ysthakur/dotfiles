# Common configuration for all laptops
{ home-manager, pkgs, system, nixpkgs, nix-index-database }:

{
  # Helper to create config
  createConfig = {username, hostname, extraPkgs ? [], extra ? {}}:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        nix-index-database.hmModules.nix-index
        (pkgs.lib.recursiveUpdate {
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

            direnv.enable = true;
            direnv.nix-direnv.enable = true;

            # cat with colors and more
            bat.enable = true;

            # Run commands without installing (uses nix-shell)
            nix-index-database.comma.enable = true;
          };
          home = {
            username = username;
            homeDirectory = "/home/${username}";
            packages = with pkgs; [
              git
              # For managing dotfiles
              chezmoi
              # For managing different versions of everything
              # asdf-vm # rtx supposedly better than asdf
              rtx
              # Show disk usage visually
              ncdu
              # Shiny, rusty new Powershell-like shell
              nushellFull
              nu_scripts
              # Shiny, rusty cd replacement
              zoxide
              # ls replacement
              eza
              # For prompt
              oh-my-posh
              # Terminal multiplexer
              zellij
              # Modal editor
              helix
            ] ++ extraPkgs;
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
        } extra)
      ];
    };
}

