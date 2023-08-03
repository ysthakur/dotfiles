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
	    packages = with pkgs; [
	      # For managing dotfiles
              chezmoi
              # For managing different versions of everything
              asdf-vm
	      # Show disk usage visually
	      ncdu
	    ] ++ extraPkgs;
            sessionVariables = {
              HOSTNAME = hostname;
              EDITOR = "vim";
              BROWSER = "firefox";
            };
	    stateVersion = "23.05";
	  };
	} extra)
      ];
    };
}

