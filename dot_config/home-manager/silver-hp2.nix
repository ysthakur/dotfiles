{ pkgs, util }:

{
  ysthakur = util.createConfig {
    username = "ysthakur";
    hostname = "silver-hp2";
    extraPkgs = with pkgs; [
        # For image metadata
        exif
        # Go language
        go
        # GitHub CLI
        gh
        # For recording terminal sessions
        asciinema
        # For CMSC 430
        nasm
        neofetch
        (texlive.combine {
          inherit (pkgs.texlive) scheme-basic
          latexmk latexindent titlesec datetime parskip etoolbox mathtools fmtcount xkeyval soul listings;
        })
        # Alternative to LaTeX
        typst
        # File explorer
        xfce.thunar
      ];
    extra = {
      home.sessionVariables = {
        GOBIN = "/home/ysthakur/go/bin";
      };
    };
  };
}

