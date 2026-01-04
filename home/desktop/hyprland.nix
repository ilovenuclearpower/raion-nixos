{ config, pkgs, ... }:

{
  # Hyprland configuration

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    
    settings = {
      # Monitor configuration
      monitor = [
        "DP-3,2560x1440@240,0x0,1"
        "HDMI-A-1,3840x2160@60,2560x0,1"
      ];

      # Workspace to monitor binding
      workspace = [
        "1, monitor:DP-3, default:true"
        "2, monitor:DP-3"
        "3, monitor:DP-3"
        "4, monitor:DP-3"
        "5, monitor:DP-3"
        "6, monitor:HDMI-A-1, default:true"
        "7, monitor:HDMI-A-1"
        "8, monitor:HDMI-A-1"
        "9, monitor:HDMI-A-1"
        "10, monitor:HDMI-A-1"
      ];
      
      # Startup applications
      exec-once = [
        "kitty --class=btop -e btop"
        "kitty --class=ncspot -e ncspot"
        "kitty --class=cava -e cava"
        "kitty --class=stmp -e stmp"
        "hypridle"
        "waybar"
        "wl-paste --type text --watch cliphist store" # Cliphist store text
        "wl-paste --type image --watch cliphist store" # Cliphist store images
      ];
      
      # Input configuration
      input = {
        kb_layout = "us";
        kb_options = "caps:escape";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };
      
      # General settings
      general = {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 3;
        layout = "dwindle";
        allow_tearing = false;
      };
      
      # Decoration settings
      decoration = {
        rounding = 0;
        blur = {
            enabled = false;
          };
      };
      
      # Animation settings
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      # Layout settings
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      # Window rules
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "float, class:(pavucontrol)"
        "float, class:(nautilus)"
        "workspace 6 silent, class:^(btop)$"
        "workspace 6 silent, class:^(cava)$"
        "workspace 6 silent, class:^(stmp)$"
        "workspace 6 silent, class:^(ncspot)$"
        "workspace 7, title:^(Steam Big Picture Mode)$"
        "workspace 7, class:^(steam)$,title:^(Steam Big Picture Mode)$"
      ];
      
      # Keybindings
      "$mainMod" = "ALT";
      
      bind = [
        # Basic bindings
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, nautilus"
        "$mainMod, F, togglefloating,"
        "$mainMod, R, exec, rofi -show drun"
        "$mainMod, P, pseudo,"
        "$mainMod, S, togglesplit,"
	      "$mainMod, B, exec, firefox"
        
        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

	# Move focus with mainMod + hjkl
	"$mainMod, h, movefocus, l"
	"$mainMod, l, movefocus, r"
	"$mainMod, j, movefocus, u"
	"$mainMod, k, movefocus, d"
        
        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        # Screenshot bindings
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mainMod, Print, exec, grim - | wl-copy"
        "$mainMod SHIFT, Print, exec, grim ~/$(date +'%Y%m%d_%Hh%Mm%Ss_grim.png')"
        
        # Volume controls
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        
        # Screen lock
        "SUPER, L, exec, loginctl lock-session"

        # Clipboard
        "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        "$mainMod SHIFT, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy && wtype -M ctrl v -m ctrl"
      ];
      
      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
