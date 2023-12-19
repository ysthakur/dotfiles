{ username, hostname, pkgs, util }:

let theiaPackages = with pkgs; [ sqlite sqlite.dev ];
in
{
  ${username} = util.createConfig {
    username = username;
    hostname = hostname;
    extraPkgs = (with pkgs; [
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
        (texlive.combine {
          inherit (pkgs.texlive) scheme-basic
          latexmk latexindent titlesec datetime parskip etoolbox mathtools fmtcount xkeyval soul listings;
        })
        # Alternative to LaTeX
        typst
        # File explorer
        xfce.thunar
      ]) ++ theiaPackages;
    extra = {
      home.sessionVariables = {
        GOBIN = "/home/ysthakur/go/bin";
      };
    };
  };
}
