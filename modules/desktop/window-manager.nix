{lib, ...}: {
  modules.wm.nixos = {...}: {
    options.stgs.user.wm = lib.mkOption {
      type = lib.types.enum [ "mango" "sway" "niri" ];
      description = "Which window manager to enable.";
    };

    config = {
      programs.dconf.enable = true;
      security.polkit.enable = true;
    };
  };

  modules.login.nixos = {config, pkgs, ...}: {
    # Autologin and window manager startup.
    services.getty.autologinUser = config.stgs.user.name;

    environment.loginShellInit =  with config.programs; ''
      if [ "$(tty)" = "/dev/tty1" ]; then
      ${uwsm.package}/bin/uwsm start ${config.stgs.user.wm}-uwsm.desktop
    fi
    '';

    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        mango = {
          binPath = "${pkgs.mango}/bin/mango";
          prettyName = "MangoWC";
          comment = "A feature rich Wayland compositor.";
        };
      };
    };
  };
}
