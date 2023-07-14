# Configuration for i3status-rust
let
  # Copied from Dracula theme
  idle_bg = "#282a36";
  idle_fg = "#f8f8f2";
  info_bg = "#8be9fd";
  info_fg = "#282a36";
  good_bg = "#50fa7b";
  good_fg = "#282a36";
  warning_bg = "#f1fa8c";
  warning_fg = "#282a36";
  critical_bg = "#ff5555";
  critical_fg = "#282a36";
  alternating_tint_bg = "#111111";
  alternating_tint_fg = "#111111";
in {
  bottom = {
    icons = "material-nf";
    theme = "dracula";
    settings = {
      theme = {
        theme = "dracula";
        overrides = {
          inherit
            idle_bg idle_fg
            info_bg info_fg
            good_bg good_fg
            warning_bg warning_fg
            critical_bg critical_fg
            alternating_tint_bg alternating_tint_fg;
        };
      };
    };
    blocks = [
      {
         block = "net";
         format = " $icon {$signal_strength|no wifi} ";
         format_alt = " $icon {$ssid|Wired} ^icon_net_down$speed_down.eng(prefix:K) ^icon_net_up$speed_up.eng(prefix:K) ";
         theme_overrides = {
           idle_bg = info_bg;
           idle_fg = info_fg;
           info_bg = warning_bg;
           info_fg = warning_fg;
         };
      }
      {
         block = "disk_space";
         format = " $icon $available ";
         format_alt = " $icon $available/$total ";
         path = "/";
         info_type = "available";
         interval = 60;
         warning = 20.0;
         alert = 10.0;
       }
       {
         block = "memory";
         format = " $icon $mem_total_used_percents ";
         format_alt = " $icon $mem_total_used.eng(w:3)/$mem_total.eng(w:3) ";
         warning_mem = 85.0;
       }
       {
         block = "cpu";
         interval = 1;
         theme_overrides = {
           idle_bg = info_bg;
           idle_fg = info_fg;
         };
       }
       {
         block = "load";
         interval = 1;
         format = " $icon $1m ";
         theme_overrides = {
           idle_bg = info_bg;
           idle_fg = info_fg;
         };
       }
       {
         block = "sound";
       }
       {
         block = "battery";
         format = " $icon $percentage ";
         full_format = " $icon $percentage ";
         not_charging_format = " $icon $percentage {($time) |}";
         good = 85;
         warning = 40;
         critical = 20;
         theme_overrides = {
           # So that full battery has good_bg
           idle_bg = good_bg;
           idle_fg = good_fg;
         };
       }
       {
         block = "time";
         interval = 60;
         format = " $timestamp.datetime(f:'%a %d/%m %R') ";
       }
    ];
  };
}

