# Common configuration for all laptops
{ home-manager, pkgs, system, nixpkgs }:

{
  # Helper to create config
  createConfig = {username, hostname, extraPkgs ? [], extra ? {}}:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        (pkgs.lib.recursiveUpdate {
          programs.home-manager.enable = true;
          programs = {
            kakoune.enable = true;

            direnv.enable = true;
            direnv.nix-direnv.enable = true;

            # cat with colors and more
            bat.enable = true;
          };
          home = {
            username = username;
            homeDirectory = "/home/${username}";
            packages = with pkgs; [
              git
              # For managing dotfiles
              chezmoi
              # For managing different versions of everything
              asdf-vm
              # Show disk usage visually
              ncdu
              # Shiny, rusty new Kakoune-like editor
              helix
              # Shiny, rusty new Powershell-like shell
              nushell
              # Shiny, rusty cd replacement
              zoxide
              # For prompt
              oh-my-posh
            ] ++ extraPkgs;
            sessionVariables = {
              HOSTNAME = hostname;
              EDITOR = "vim";
              BROWSER = "firefox";
              # Use bat to highlight manpages
              MANPAGER="sh -c 'col -bx | bat -l man -p'";
            };
            stateVersion = "23.05";
          };
        } extra)
      ];
    };
}

