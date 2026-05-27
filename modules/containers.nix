{...}: {
  modules.containers.nixos = {...}: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  modules.containers.home = {...}: {
    programs.distrobox = {
      enable = true;
    };
  };
}
