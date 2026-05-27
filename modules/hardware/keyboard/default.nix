{...}: {
  modules.kanata.nixos = {...}: {
    # Kanata is my main keyboard remapping tool.
    services.kanata = {
      enable = true;

      keyboards.myLayout = {
        config = builtins.readFile ./config.kbd;

        extraDefCfg = ''
          process-unmapped-keys yes
       concurrent-tap-hold yes
        '';
      };
    };
  };

  modules.XCompose.home = {...}: {
    # Compose file.
    home.file.".XCompose" = {
      source = ./XCompose;
    };
  };

  modules.espanso.nixos = {pkgs, ...}: {
    services.espanso = {
      enable = true;
      package = pkgs.espanso-wayland;
    };
  };

  modules.espanso.home = {pkgs, ...}: let yamlFormat = pkgs.formats.yaml {}; in {
    xdg.configFile."espanso/config/default.yml".source =
      yamlFormat.generate "espanso-config-default" {
        undo_backspace = true;

        toggle_key = "RIGHT_ALT";
        search_shortcut = "CTRL+ALT+META+SPACE";

        inject_delay = 5;
      };

    xdg.configFile."espanso/match/accents.yml".source =
      yamlFormat.generate "espanso-config-accents.yml" {
        matches = [
          { trigger = ":ss";  replace = "ß"; }
          { trigger = ":u\""; replace = "ü"; }
          { trigger = ":U\""; replace = "Ü"; }
          { trigger = ":a\""; replace = "ä"; }
          { trigger = ":A\""; replace = "Ä"; }
          { trigger = ":o\""; replace = "ö"; }
          { trigger = ":O\""; replace = "Ö"; }
        ];
      };
  };
}
