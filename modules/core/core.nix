{...}: {
  modules.core.nixos = {inputs, pkgs, ...}: {
    environment.systemPackages =
      let system = pkgs.stdenv.hostPlatform.system; in [
        # Nix alien for external binaries support.
        inputs.nix-alien.packages.${system}.nix-alien
      ];
  };
}
