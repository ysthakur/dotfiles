{ username, hostname, pkgs, util, extraPkgs ? [] }:

let theiaPackages = with pkgs; [ sqlite sqlite.dev ];
in
{
  ${username} = util.createConfig {
    inherit username hostname;
    extraPkgs = (with pkgs; [
        # For image metadata
        exif
        # Go language
        go
        # GitHub CLI
        gh
        # For recording terminal sessions
        asciinema
        (texlive.combine {
          inherit (pkgs.texlive) scheme-basic
          latexmk latexindent titlesec datetime parskip etoolbox mathtools fmtcount xkeyval soul listings;
        })
        # Alternative to LaTeX
        typst
        # File explorer
        xfce.thunar
        # Website builder
        hugo
      ]) ++ theiaPackages ++ extraPkgs;
    extra = {
      home.sessionVariables = {
        GOBIN = "/home/ysthakur/go/bin";
      };
    };
  };
}

