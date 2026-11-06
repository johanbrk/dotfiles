{...}: {
  modules.desktop-utilities.home = {pkgs, ...}: {
    home.packages = [
      pkgs.gammastep
    ];
  };
}
