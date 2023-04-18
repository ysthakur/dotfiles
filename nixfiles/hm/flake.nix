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
      util = import ./util.nix { inherit pkgs system nixpkgs home-manager; };
      hostname =
        if builtins.pathExists ./hostname.nix then import ./hostname.nix
        else builtins.abort "No hostname.nix in ~/nixfiles";
    in {
      defaultPackage.${system} = home-manager.defaultPackage.${system};

      homeConfigurations = import ./${hostname}.nix { inherit pkgs util; };
    };
}

