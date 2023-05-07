{ pkgs, util }:

{
  yash = util.createConfig {
    username = "yash";
    hostname = "old-lenovo";
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
        TERMINAL = "alacritty";
      };

      services.screen-locker = {
        enable = true;
        inactiveInterval = 10;
        lockCmd = "${pkgs.i3lock}/bin/i3lock --ignore-empty-password --show-failed-attempts --image=/home/yash/screensaver.png";
        xautolock = {
          enable = true;
          extraOptions = let notifyTime = "30"; in [
            "-killtime" "15" # Wait 15 minutes before going to sleep
            "-killer" "\"/run/current-system/systemd/bin/systemctl suspend\""
            "-notify" notifyTime
            "-notifier \"${pkgs.libnotify}/bin/notify-send 'Locking in ${notifyTime}' seconds\""
            "-detectsleep"
          ];
        };
      };
    };
  };
}
