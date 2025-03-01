{
  pkgs,
  util,
  flakePkgs,
}:

let
  username = "yash";
in
{
  inherit username;
  modules = [
    {
      programs.i3status-rust = {
        enable = true;
        bars = import ./i3status-rust.nix;
      };

      programs.rofi = {
        enable = true;
      };

      home = {
        packages = with pkgs; [
          # Get type of files
          file
          firefox
          kdePackages.kate
          git
          (python310.withPackages (
            ps: with ps; [
              # virtualenvwrapper
            ]
          ))
          # File explorer
          nemo
          xautolock
          # See names for events like keys
          xorg.xev
          # Simulate keypresses
          xdotool
          # flakePkgs.ghostty
        ];
        sessionVariables = {
          TERMINAL = "alacritty";
          # To prevent Zellij from running (no need for it with i3)
          ZELLIJ = "non-empty string";
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Arc-Lighter";
          package = pkgs.arc-theme;
        };
      };

      services.screen-locker = {
        enable = true;
        inactiveInterval = 10;
        lockCmd = "${pkgs.i3lock}/bin/i3lock --ignore-empty-password --show-failed-attempts --image=/home/yash/screensaver.png";
        xautolock = {
          enable = true;
          extraOptions =
            let
              notifyTime = "30";
            in
            [
              "-corners"
              "----" # Don't sleep if mouse in any corner
              "-killtime"
              "15" # Wait 15 minutes before going to sleep
              "-killer"
              "\"/run/current-system/systemd/bin/systemctl suspend\""
              "-notify"
              notifyTime
              "-notifier \"${pkgs.libnotify}/bin/notify-send 'Locking in ${notifyTime}' seconds\""
              "-detectsleep"
            ];
        };
      };
    }
  ];
}
