{ username, hostname, pkgs, util, extraPkgs ? [] }:
{
  ${username} = util.createConfig {
    inherit username hostname;
    extraPkgs = (with pkgs; [
        # GitHub CLI
        gh
        # For recording terminal sessions
        asciinema
        (texlive.combine {
          inherit (pkgs.texlive) scheme-basic
          latexmk latexindent titlesec datetime parskip etoolbox mathtools fmtcount xkeyval soul listings;
        })
        # File explorer
        xfce.thunar
        # Website builder
        hugo
      ]) ++ extraPkgs;
    extra = {
      home.sessionVariables = {
        GOBIN = "/home/ysthakur/go/bin";
      };
    };
  };
}

