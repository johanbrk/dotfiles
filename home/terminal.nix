{pkgs, config, ...}: {
  # Better cli interface for nixos.
  programs.nh.enable = true;

  # Main tui text editor.
  programs.helix = {
    enable = true;
    settings.editor.line-number = "relative";
  };

  # Default terminal.
  programs.kitty = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font Mono";
      package = pkgs.nerd-fonts.fira-code;
      size = 10.5;
    };

    settings = {
      shell = "${config.programs.nushell.package}/bin/nu";
      kitty_mod = "super+ctrl+alt";
      disable_ligatures = "cursor";
      cursor_trail = 3;
    };
  };

  programs.zellij = {
    enable = true;
    settings.default_shell = "${config.programs.nushell.package}/bin/nu";
  };

  # Nushell is my terminal shell.
  programs.nushell = {
    enable = true;

    # Here I can configure $env.config options.
    settings = {
      show_banner = false;
      edit_mode = "emacs";
      cursor_shape.emacs = "line";
    };

    # Shell alias definitions.
    shellAliases = {
      gst = "git status";
      gdf = "git diff";
      enw = "emacsclient -t";
    };

    extraConfig = "$env.LS_COLORS = (vivid generate stylix)";
  };

  # Add extra autoloads file for useful nushell scripts.
  xdg.configFile."nushell/autoload/extra.nu".source = ./extra.nu;

  # Primary document viewer.
  programs.zathura.enable = true;

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };

  # Carapace completes command arguments.
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Atuin improves the shell's awareness of context in history.
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Starship provides a pretty prompt for nushell.
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  services.pueue.enable = true;

  # Pandoc is a file format converter.
  programs.pandoc.enable = true;

  # Btop is a htop-like resource monitor.
  programs.btop.enable = true;

  # Zoxide is an autojumping cd.
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Add common terminal utilities.
  programs.fd.enable = true;      # Finder.
  programs.ripgrep.enable = true; # Modern grep.
  programs.fzf.enable = true;     # Fuzzy search.
  programs.fzf.historyWidget.command = "";

  # Modern terminal file viewer.
  programs.bat.enable = true;

  programs.newsboat = {
    enable = true;

    urls = [
      { tags = [ "haskell" "functional programming" ];
        url = "https://planet.haskell.org/rss20.xml";
      }
    ];
  };
}
