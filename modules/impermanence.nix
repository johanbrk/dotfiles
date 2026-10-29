{...}: {
  modules.impermanence.nixos = {config, ...}: {
    environment.persistence."/persistent" = {
      hideMounts = true;
      # Persist directories and all subdirectories.
      directories = [
        # Remember internet connections, leases, and bluetooth.
        "/var/lib/iwd"
        "/var/lib/dhcpcd"
        "/var/lib/bluetooth"

        # Remember logs.
        "/var/log"

        "/var/lib/nixos"            # Important to preserve file permissions.
        "/var/lib/systemd/coredump" # Coredumps storage.

        # Remember vpn state.
        "/etc/mullvad-vpn"
        "/var/cache/mullvad-vpn"

        # If this directory is not persisted timers won't persist.
        "/var/lib/systemd/timers"

        # Persist printing directories.
        "/var/cache/cups"
        "/var/spool/cups"
        "/var/lib/cups"
      ];

      # Persist files.
      files = [
        "/etc/machine-id"
      ];

      users.${config.stgs.user.name} = {
        # User directories and subdirectories.
        directories = [
          # Standard user directories.
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"

          # Code and dotfiles.
          ".dotfiles"
          "Projects"

          # Application data.
          ".local/share/direnv"
          ".local/share/zoxide"
          ".local/share/atuin"
          ".local/share/Anki2"

          ".local/share/fonts"    # Important for fira code in Emacs.

          ".local/state/wireplumber" # Persist volume information.

          # Stateful data for flatpaks.
          ".local/share/flatpak"
          ".var/app"

          ".config/opensnitch"    # Opensnitch-ui configuration.
          ".librewolf"

          ".config/espanso/match/packages"

          # Syncthing state.
          ".local/state/syncthing"
        ];

        # User files.
        files = [
          # Important emacs files.
          ".config/emacs/.mc-lists.el"
          ".config/emacs/bookmarks"

          ".config/nushell/history.txt" # Shell history.
        ];
      };
    };

    # Declarative rule to create snapper subvolume (It errors out otherwise).
    systemd.tmpfiles.rules = [ "v /persistent/.snapshots 0700 root root - -" ];

    # Snapshot my persistent data.
    services.snapper = {
      configs = {
        persistent = {
          SUBVOLUME = "/persistent";

          # Timeline settings.
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;

          TIMELINE_LIMIT_YEARLY = 0;
        };
      };
    };
  };
}
