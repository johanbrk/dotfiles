{inputs, ...}: {
  modules.emacs.nixos = {...}: {
    # Declare emacs system overlay.
    nixpkgs.overlays = [
      inputs.emacs-overlay.overlays.default
    ];
  };

  modules.emacs.home = {pkgs, ...}: {
    # Enable emacs background service.
    services.emacs = {
      enable = true;
      defaultEditor = true;
    };

    home.packages = [
      pkgs.texlive.combined.scheme-full
    ];

    # Main gui text editor.
    programs.emacs = {
      enable = true;

      extraPackages = epkgs: with epkgs; [
        # Navigation and selection plugins for Emacs.
        avy
        consult
        vertico
        embark
        embark-consult
        expand-region
        orderless
        puni
        activities
        beframe

        # Integration with direnv.
        envrc

        # Language modes.
        idris2-mode
        haskell-ts-mode
        nix-ts-mode
        markdown-mode
        nushell-mode
        uiua-ts-mode
        bqn-mode
        j-mode
        racket-mode
        fennel-mode
        treesit-grammars.with-all-grammars

        # Code completion plugins.
        corfu
        yasnippet

        # Editing plugins.
        wgrep
        multiple-cursors

        # Documentation plugins.
        marginalia
        eldoc-box
        consult-hoogle

        # Terminal related packages.
        eat
        kkp

        # Git.
        magit
        magit-delta
        git-gutter

        # Misc.
        zoom
        pandoc-mode
        vundo
        try
        pdf-tools
        dirvish

        # Latex.
        auctex
        cdlatex
        org-fragtog
        anki-editor

        # Themes.
        doom-themes
        base16-theme
        org-superstar
        fira-code-mode
      ];

      package = (pkgs.emacs-igc-pgtk.overrideAttrs (prev: {
        NIX_CFLAGS_COMPILE = (prev.NIX_CFLAGS_COMPILE or []) ++
                          [ "-O3" "-march=native"
                            "-fgcse-las" "-fgcse-sm"
                            "-pipe" "-fno-semantic-interposition" ];
        configureFlags = (prev.configureFlags or []) ++ [
          "--without-x"
          "--without-compress-install"
          "--without-xim"
          "--without-gconf"
          "--without-xinput2"
          "--enable-link-time-optimization"
        ];
      }));
    };

    # Copy Emacs elisp configuration into its appropriate folder.
    xdg.configFile."emacs" = {
      source = ./emacs.d;
      recursive = true;
    };
  };
  }
