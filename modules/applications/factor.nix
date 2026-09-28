{...}: {
  modules.languages.home = {pkgs, ...}: {
    home.packages = [
      pkgs.factor-lang
    ];
  };
}
