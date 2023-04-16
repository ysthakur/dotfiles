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
      # Get laptop-specific configuration
      getConfig = file: (import file { inherit pkgs util; });
    in {
      defaultPackage.${system} = home-manager.defaultPackage.${system};

      homeConfigurations = (getConfig ./old-lenovo.nix) // (getConfig ./silver-hp2.nix);
    };
}

