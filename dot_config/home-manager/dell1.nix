{ pkgs, util, flakePkgs }:

(import ./wsl.nix {
  inherit pkgs util;
  username = "ysthakur";
  hostname = "dell1";
  extraPkgs = with pkgs; [
  ];
})
