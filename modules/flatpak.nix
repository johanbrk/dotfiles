{...}: {
  modules.flatpak.nixos = {...}: {
    # Enable flatpak.
    services.flatpak.enable = true;
  };

  modules.flatpak.home = {inputs, config, ...}: {
    imports = [ inputs.flatpaks.homeModules.default ];

    # Configure flatpak packages.
    services.flatpak = {
      enable = true;

      remotes = {
        flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };

      packages = [
        "flathub:app/ch.tlaun.TL//stable"
        "flathub:app/com.github.Anuken.Mindustry//stable"
        "flathub:app/com.usebottles.bottles//stable"
        "flathub:app/io.github.flattool.Warehouse//stable"
        "flathub:app/net.veloren.airshipper//stable"
        "flathub:app/org.libreoffice.LibreOffice//stable"
        "flathub:app/org.onlyoffice.desktopeditors//stable"
        "flathub:app/org.processing.processingide//stable"
        "flathub:app/org.torproject.torbrowser-launcher//stable"
        "flathub:app/us.zoom.Zoom//stable"
      ];

      overrides = {
        global = {
          Environment.GTK_THEME = config.gtk.theme.name;

          Context.filesystems = [
            "/nix/store:ro"
            "xdg-config/gtk-4.0:ro"
            "xdg-config/gtk-3.0:ro"
          ];
        };

        "net.veloren.airshipper" = {
          Context.sockets = [ "!fallback-x11" "!x11" ];
        };

        "org.libreoffice.LibreOffice" = {
          Context = {
            sockets = [
              "!fallback-x11" "!x11"
            ];

            filesystems = [
              "!host" "xdg-documents/LibreOffice"
            ];
          };
        };
      };
    };
  };
}
