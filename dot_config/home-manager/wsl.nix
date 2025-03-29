{
  username,
  pkgs,
}:

let myTexPkgs = 
  with pkgs;
  (texlive.combine {
    inherit (pkgs.texlive)
      scheme-basic
      latexmk
      latexindent
      titlesec
      datetime
      parskip
      etoolbox
      mathtools
      fmtcount
      xkeyval
      soul
      listings
      ;
  });
in
{
  home = {
    packages = with pkgs; [
      # GitHub CLI
      gh
      # For recording terminal sessions
      asciinema
      # myTexPkgs
    ];
    sessionVariables = {
      GOBIN = "/home/${username}/go/bin";
    };
  };
}
