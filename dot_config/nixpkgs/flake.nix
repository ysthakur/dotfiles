{
  description = "Home Manager Flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, home-manager, ...}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      ocamlPackages = pkgs.recurseIntoAttrs pkgs.ocaml-ng.ocamlPackages_latest;
      # Helper with common config
      baseConfig = {username, extraPkgs ? []}: {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          {
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
                pkgs.exa
                # Show disk usage visually
                pkgs.ncdu
              ] ++ extraPkgs;
              stateVersion = "22.11";
            };
          }
        ];
      };
    in {
      defaultPackage.${system} = home-manager.defaultPackage.${system};

      homeConfigurations.yash = home-manager.lib.homeManagerConfiguration (baseConfig {
        username = "yash";
      });
      homeConfigurations.ysthakur = home-manager.lib.homeManagerConfiguration (baseConfig {
        username = "ysthakur";
        extraPkgs = [
            pkgs.ruby_3_1
            # Build system for OCaml
            #pkgs.dune_2
          ] ++ (with ocamlPackages; [
            #ocaml
            #findlib
            #core
            #ounit
            #utop
            #qcheck
          ]);
      });
    };
}

