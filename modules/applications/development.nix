{...}: {
  modules.development.home = {pkgs, ...}: {
    home.packages = with pkgs; [
      nixd markdown-oxide taplo
      typst tinymist
      bash-language-server shellcheck
      vscode-langservers-extracted
      tealdeer
      pkgs.cbqn-replxx pkgs.bqn386 # BQN and BQN font.
    ];

    # Enable direnv to automatically enter nix shell environments.
    programs.direnv = {
      enable = true;
      enableNushellIntegration = true;

      # Nix direnv integration.
      nix-direnv.enable = true;
    };

    # Rizin reverse engineering tool.
    programs.rizin = {
      enable = true;
    };

    # Git configuration.
    programs.git = {
      enable = true;

      settings = {
        pull.rebase = true;
        http.postBuffer = 10485760; # Set git file size limit in bytes.
      };
    };

    # Use delta for git diff.
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
