{pkgs, ...}: {
  gtk = {
    enable = true;

    iconTheme.name = "Papirus-Dark";
    iconTheme.package = (pkgs.papirus-icon-theme.override { color = "green"; });
  };

  # Cursor theme.
  home.pointerCursor = {
    name = "Adwaita";
    enable = true;

    package = pkgs.adwaita-icon-theme;
    size = 24;

    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

    # LS_COLORS theming.
  programs.vivid.enable = true;

  stylix.targets.librewolf.profileNames = [ "default" ];

  stylix.targets.kitty.fonts.enable = false;
  stylix.targets.rofi.fonts.enable = false;

  stylix.targets.emacs.fonts.enable = false;
  stylix.fonts.sizes.applications = 10.5;
}
