{...}: {
  modules.development.home = {...}: {
    # Rizin reverse engineering tool.
    programs.rizin = {
      enable = true;
    };
  };
}
