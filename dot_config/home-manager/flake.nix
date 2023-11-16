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
  };

  outputs = { nixpkgs, home-manager, nix-index-database, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # Allow unfree packages like Obsidian
        config.allowUnfree = true;
      };
      util = import ./util.nix { inherit pkgs system nixpkgs home-manager nix-index-database; };
      hostname =
        if builtins.pathExists ./hostname.nix then import ./hostname.nix
        else builtins.abort "No hostname.nix in ~/nixfiles";
    in {
      defaultPackage.${system} = home-manager.defaultPackage.${system};

      homeConfigurations = import ./${hostname}.nix { inherit pkgs util; };
    };
}

