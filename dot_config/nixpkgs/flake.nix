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
    in {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

    homeConfigurations =
      let
        ocamlPackages = pkgs.recurseIntoAttrs pkgs.ocaml-ng.ocamlPackages_latest;
      in {
      "ysthakur" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        modules = [
          {
            home.username = "ysthakur";
            home.homeDirectory = "/home/ysthakur";
            programs.home-manager.enable = true;

            home.packages = [
              # For managing dotfiles
              pkgs.chezmoi
              # GitHub CLI
              pkgs.gh
              # Prettier ls alternative
              pkgs.exa
              # Like Powershell but for Linux
              pkgs.nushell
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

            home.stateVersion = "22.11";
          }
        ];
      };
    };
  };
}

