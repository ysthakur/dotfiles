{
  username,
  pkgs,
}:

{
  home = {
    packages = with pkgs; [
      # GitHub CLI
      gh
      # For recording terminal sessions
      asciinema
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
      })
      # File explorer
      xfce.thunar
    ];
    sessionVariables = {
      GOBIN = "/home/${username}/go/bin";
    };
  };
}
