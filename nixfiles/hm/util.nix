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
	  home = {
	    username = username;
	    homeDirectory = "/home/${username}";
	    packages = [
	      # For managing dotfiles
	      pkgs.chezmoi
	      # GitHub CLI
	      pkgs.gh
	      # Prettier ls alternative
	      # pkgs.exa
	      # Show disk usage visually
	      pkgs.ncdu
	    ] ++ extraPkgs;
            sessionVariables = {
              HOSTNAME = hostname;
              EDITOR = "vim";
              BROWSER = "firefox";
            };
	    stateVersion = "22.11";
	  };
	} extra)
      ];
    };
}

