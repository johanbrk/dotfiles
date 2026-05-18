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
    (pkgs.j.overrideAttrs (oldAttrs: {
      NIX_CFLAGS_COMPILE = " -std=gnu17 -Wno-error";
      NIX_CPPFLAGS_COMPILE = " -include stdint.h";

      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.prelink ];
      postFixup = (oldAttrs.postFixup or "") + "execstack -c $out/bin/libj.so";
    }))
    pkgs.uiua
    pkgs.cbqn-replxx pkgs.bqn386
  ];

  programs.anki = {
    enable = true;
    addons = with pkgs.ankiAddons; [ review-heatmap anki-connect ];
  };
}
