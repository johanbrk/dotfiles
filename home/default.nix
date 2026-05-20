{pkgs, ...}: {
  imports = [
    ./niri.nix
    ./terminal.nix
    ./theming.nix
  ];

  home.packages = [
    pkgs.octaveFull
    pkgs.texmacs pkgs.maxima
    pkgs.lyx
    pkgs.idris2
    pkgs.idris2Packages.idris2Lsp pkgs.idris2Packages.pack
    pkgs.j pkgs.uiua
    pkgs.cbqn-replxx pkgs.bqn386
  ];

  programs.anki = {
    enable = true;
    addons = with pkgs.ankiAddons; [ review-heatmap anki-connect ];
  };
}
