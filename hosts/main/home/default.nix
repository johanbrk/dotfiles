{pkgs, config, rootPath, ...}: {
  home.username = "johannes";
  home.homeDirectory = "/home/johannes";
  programs.home-manager.enable = true;

  imports = [
    /${rootPath}/home
  ];

  home.packages = with pkgs; [
    wineWow64Packages.waylandFull winetricks
    bluetuith
    musescore
    (hunspell.withDicts (d: [ d.en-us-large ]))
    zip unzip

    # Add custom system update script to system path.
    (writeShellApplication {
      name = "update-system";
      runtimeInputs = [ config.programs.nushell.package ];
      text = /${rootPath}/home/scripts/update-system.nu;
    })

    podman podman-tui
  ];

  home.sessionVariables = {
    GTK_THEME = config.gtk.theme.name;
  };

  programs.bash.enable = true;

  # Password manager.
  programs.keepassxc = {
    enable = true;

    settings = {
      GUI = {
        CompactMode = true;
        ApplicationTheme = "classic";
      };
    };
  };

  xdg = {
    enable = true;

    # Enable and configure xdg mime.
    mimeApps = {
      enable = true;

      defaultApplications = {
        # Use mpv for video.
        "video/mp4" = "mpv.desktop";

        # Open text files using emacs.
        "text/plain" = "emacs.desktop";
      };
    };

    # Autogenerate user directories.
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Enabled this service for better bluetooth control of audio devices.
  services.mpris-proxy.enable = true;

  # Make gtk apps use emacs keybindings for text boxes.
  dconf.settings."org/gnome/desktop/interface".gtk-key-theme = "Emacs";

  programs.mpv.enable = true;

  # Set user specific git information.
  programs.git.settings.user = {
    name = "Johannes";
    email = "johannes.barjak@gmail.com";
  };

  # Display scaling service.
  services.shikane = {
    enable = true;
    settings.profile = [
      {
        name = "Builtin laptop monitor.";
        output = [
          {
            match = "eDP-1";
            enable = true;
            scale = 1.25;
          }
        ];
      }
    ];
  };

  home.stateVersion = "26.05";
}
