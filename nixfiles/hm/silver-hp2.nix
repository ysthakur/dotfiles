{ pkgs, util }:

{
  ysthakur = util.createConfig {
    username = "ysthakur";
    hostname = "silver-hp2";
    extraPkgs = with pkgs; [
        # For image metadata
        exif
        go
      ];
    extra = {
      home.sessionVariables = {
        GOBIN = "/home/ysthakur/go/bin";
      };
    };
  };
}

