# Packages for CMSC631
{ pkgs }:

{
  programs = {
    emacs.enable = true; # Separately install Doom Emacs
  };
  home.packages = (
    with pkgs;
    [
#      coq # Need Coq 8.17.1 for class but whatever
      ripgrep # Needed for Doom Emacs
      coqPackages.vscoq-language-server
    ]
  );
}
