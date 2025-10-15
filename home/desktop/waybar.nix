{ config, pkgs, inputs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 4;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "mpris" "clock" ];
        modules-right = [ 
          "idle_inhibitor" 
          "pulseaudio" 
          "network" 
          "cpu" 
          "memory" 
          "tray" 
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "6" = "󰲪";
            "7" = "󰲬";
            "8" = "󰲮";
            "9" = "󰲰";
            "10" = "󰿬";
            urgent = "";
            active = "";
            default = "";
          };
          on-click = "activate";
        };

        "hyprland/window" = {
          format = " {}";
          max-length = 50;
          separate-outputs = true;
        };

        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "▶";
            mpv = "🎵";
            spotify = "󰓇";
            ncspot = "󰓇";
          };
          status-icons = {
            paused = "⏸";
          };
          ignored-players = ["firefox"];
          max-length = 64;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };

        clock = {
          format = "{:%H:%M} ";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "{usage}% {icon}";
          tooltip = false;
          format-icons = ["󰻠"];
        };

        memory = {
          format = "{}% {icon}";
          format-icons = ["󰍛"];
        };


        network = {
          format-wifi = "{essid} ({signalStrength}%) {icon}";
          format-ethernet = "{ipaddr}/{cidr} {icon}";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) {icon}";
          format-disconnected = "Disconnected {icon}";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-icons = {
            wifi = [""];
            ethernet = "󰈀";
            disconnected = "⚠";
          };
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡏";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰦢";
            car = "󰄋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          format-source-icons = {
            microphone = "󰍬";
            default = "󰍬";
          };
          on-click = "pavucontrol";
          on-click-right = "pavucontrol";
          scroll-step = 1;
          reverse-scrolling = true;
        };
      };
    };
  };
}
