# Packages for HACS408E
{ pkgs }:

{
  home.packages = (
    with pkgs;
    [
      nasm
    ]
  );
}
