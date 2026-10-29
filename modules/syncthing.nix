{...}: {
  modules.syncthing.home = {...}: {
    services.syncthing = {
      enable = true;
    };
  };

  modules.syncthing.nixos = {...}: {
    networking.firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}
