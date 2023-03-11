{
  description = "Home Manager Flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, home-manager, ...}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      ocamlPackages = pkgs.recurseIntoAttrs pkgs.ocaml-ng.ocamlPackages_latest;
      # Helper with common config
      createConfig = {username, extraPkgs ? [], extra ? {}}:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            (pkgs.lib.recursiveUpdate {
              programs.home-manager.enable = true;
              home = {
                username = username;
                homeDirectory = "/home/${username}";
                packages = [
                  # For managing dotfiles
                  pkgs.chezmoi
                  # GitHub CLI
                  pkgs.gh
                  # Prettier ls alternative
                  # pkgs.exa
                  # Show disk usage visually
                  pkgs.ncdu
                ] ++ extraPkgs;
                stateVersion = "22.11";
              };
            } extra)
          ];
        };
    in {
      defaultPackage.${system} = home-manager.defaultPackage.${system};

      homeConfigurations.yash = createConfig {
        username = "yash";
        extraPkgs = with pkgs; [
            # Get type of files
            file
            firefox
            kate
            git
            (python310.withPackages (ps: with ps; [
              # virtualenvwrapper
            ]))
            # File explorer
            xfce.thunar
            xautolock
            # See names for events like keys
            xorg.xev
            # Simulate keypresses
            xdotool
          ];
        extra = {
          home.sessionVariables = {
            EDITOR = "vim";
            BROWSER = "firefox";
            TERMINAL = "alacritty";
          };

          services.screen-locker = let notifyTime = "30"; in
            {
              enable = true;
              inactiveInterval = 10;
              lockCmd = "${pkgs.i3lock}/bin/i3lock --ignore-empty-password --show-failed-attempts --image=/home/yash/screensaver.png";
              xautolock = {
                enable = true;
                extraOptions = [
                  "-killtime" "20"
                  "-killer" "\"/run/current-system/systemd/bin/systemctl suspend\""
                  "-notify" notifyTime
                  "-notifier \"${pkgs.libnotify}/bin/notify-send 'Locking in ${notifyTime}' seconds\""
                ];
              };
            };
        };
      };
      homeConfigurations.ysthakur = createConfig {
        username = "ysthakur";
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
    };
}

