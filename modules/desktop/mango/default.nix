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
        exec-once = [
          "${pkgs.swaybg}/bin/swaybg -i ${config.stylix.image}"
        ];

        exec = [
          "${config.xdg.configHome}/mango/autostart.sh"
        ];

        rootcolor = "0x${base00}ff";
        bordercolor = "0x${base03}ff";
        focuscolor = "0x${base0D}ff";
        maximizescreencolor = "0x${base0D}ff";
        urgentcolor = "0x${base08}ff";
        scratchpadcolor = "0x${base0C}ff";
        globalcolor = "0x${base0E}ff";
        overlaycolor = "0x${base0B}ff";

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
