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
      hostname = builtins.getEnv "HOSTNAME";
      laptopFile =
        if hostname == "old-lenovo" then ./old-lenovo.nix
        else if hostname == "silver-hp2" then ./silver-hp2.nix
        else abort "Invalid hostname ${hostname}";
    in {
      defaultPackage.${system} = home-manager.defaultPackage.${system};

      homeConfigurations = (import laptopFile { inherit pkgs util; }).homeConfigurations;
    };
}

