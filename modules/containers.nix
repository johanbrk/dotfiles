{...}: {
  modules.containers.nixos = {...}: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  modules.containers.home = {pkgs, ...}: {
    home.packages = [ pkgs.distroshelf ];

    programs.distrobox = {
      enable = true;
    };
  };
}
