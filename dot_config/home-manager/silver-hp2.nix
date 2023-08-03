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
      ];
    extra = {
      home.sessionVariables = {
        GOBIN = "/home/ysthakur/go/bin";
      };
    };
  };
}

