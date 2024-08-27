{
  pkgs,
  util,
  flakePkgs,
}:
let
  username = "ysthakur";
in
{
  inherit username;
  modules = [
    (import ./wsl.nix { inherit pkgs username; })
    (import ./cmsc631.nix { inherit pkgs; })
  ];
}
