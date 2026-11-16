# Enable and configure rofi.
{...}: {
  modules.rofi.home = {config, pkgs, ...}: {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;

      theme = config.rofi.theme;

      # Add calculator plugin to rofi.
      plugins = [
        pkgs.rofi-calc
      ];

      settings = {
        show-icons = true;
        font = "Cousine Nerd Font Propo";

        # Change modi default text to icons.
        display-drun = "󰀻 ";
        display-window = "";

        combi-modes = [ "drun" "window" ];
        modes = [ "drun" "window" "combi" ];

        # Prefer fuzzy searching.
        sort = true;
        sorting-method = "fzf";
        matching = "fuzzy";
      };
    };
  };
}
