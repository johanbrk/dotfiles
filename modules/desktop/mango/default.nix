{config, rootPath, ...}: let cfg = config.modules; in {
  modules.mango.nixos = {inputs, pkgs, ...}: {
    imports = [ inputs.mango.nixosModules.mango ];
    environment.systemPackages = [ pkgs.wl-kbptr ];

    # Globally enable mango.
    programs.mango.enable = true;

    # Set rule for low latency in mango.
    services.ananicy.extraRules = [
      { name = "mango"; type = "LowLatency_RT"; }
    ];
  };

  modules.mango.home = {inputs, config, pkgs, ...}: {
    imports = [ inputs.mango.hmModules.mango ];

    # Portals to use with mango.
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    wayland.windowManager.mango = {
      enable = true;
      extraConfig = builtins.readFile ./config.conf;
      settings = with config.lib.stylix.colors; {
        exec_once = [
          "${pkgs.swaybg}/bin/swaybg -i ${config.stylix.image}"
        ];

        exec = [
          "${config.xdg.configHome}/mango/autostart.sh"
        ];

        root_color = "0x${base00}ff";
        border_color = "0x${base03}ff";
        focus_color = "0x${base0D}ff";
        maximized_screen_color = "0x${base0D}ff";
        urgent_color = "0x${base08}ff";
        scratchpad_color = "0x${base0C}ff";
        global_color = "0x${base0E}ff";
        overlay_color = "0x${base0B}ff";

        bind = [
          "None,XF86MonBrightnessUp,spawn,brightnessctl set 5%+"
          "None,XF86MonBrightnessDown,spawn,brightnessctl set 5%-"

          "None,XF86AudioMute,spawn,${config.programs.nushell.package}/bin/nu ${/${rootPath}/home/scripts/volume.nu} --toggle=mute"
          "None,XF86AudioRaiseVolume,spawn,${config.programs.nushell.package}/bin/nu ${/${rootPath}/home/scripts/volume.nu} --inc"
          "None,XF86AudioLowerVolume,spawn,${config.programs.nushell.package}/bin/nu ${/${rootPath}/home/scripts/volume.nu} --dec"

          "Super,b,spawn,${config.programs.librewolf.package}/bin/librewolf"
          "Super+Shift,b,spawn,${config.programs.librewolf.package}/bin/librewolf --private-window"
        ];
      };

      autostart_sh = builtins.readFile ./autostart.sh;
    };
  };
}
