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
    {
      programs = {};
      home.packages = (
        with pkgs;
        [
          typst
          ruff
        ]
      );
    }
  ];
}
