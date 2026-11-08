{pkgs, ...}: {
  imports = [
    ./terminal.nix
    ./theming.nix
  ];

  home.packages = [
    pkgs.octaveFull
    pkgs.texmacs pkgs.maxima
    pkgs.lyx
    pkgs.j pkgs.uiua
  ];

  programs.anki = {
    enable = true;
    addons = with pkgs.ankiAddons; [ review-heatmap anki-connect ];
  };
}
