{ pkgs, util, flakePkgs }:

(import ./wsl.nix {
  inherit pkgs util;
  username = "ysthakur";
  hostname = "dell1";
  extraPkgs = with pkgs; [
    # For CMSC631
    coq_8_17 # Need Coq 8.17.1
  ];
})
