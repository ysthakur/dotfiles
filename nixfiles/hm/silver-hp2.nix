{ pkgs, util }:

let ocamlPackages = pkgs.recurseIntoAttrs pkgs.ocaml-ng.ocamlPackages_latest;
in {
  ysthakur = util.createConfig {
    username = "ysthakur";
    hostname = "silver-hp2";
    extraPkgs = [
        pkgs.ruby_3_1
        # Build system for OCaml
        #pkgs.dune_2
      ] ++ (with ocamlPackages; [
        #ocaml
        #findlib
        #core
        #ounit
        #utop
        #qcheck
      ]);
  };
}

