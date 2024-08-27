# Packages for CMSC631
{ pkgs }:

{
  programs = {
    emacs.enable = true; # Separately install Doom Emacs
  };
  home.packages = (
    with pkgs;
    [
      coq_8_17 # Need Coq 8.17.1 for class
      ripgrep # Needed for Doom Emacs
    ]
  );
}
