{...}: {
  modules.factor-lang.home = {pkgs, ...}: {
    home.packages = [
      pkgs.factor-lang
    ];
  };

  modules.factor-lang.nixos = {config, ...}: {
    environment.persistence."/persistent"
    .users.${config.stgs.user.name} = {
      directories = [ ".local/share/factor/vocabularies" ];
      files = [ ".factor-roots" ];
    };
  };
}
