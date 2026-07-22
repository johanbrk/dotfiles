{lib, ...}:
let genRule = type: operand: data: { inherit type operand data; };
# These are simple allow rules that match to an exact binary.
simpleRules = rules: (lib.listToAttrs (map (rule: lib.nameValuePair rule.name {
  name = rule.name;
  enabled = true;

  action = "allow";
  duration = "always";

  operator = {
    type = "simple";
    operand = "process.path";

    sensitive = true;
    data = rule.data;
  };
}) rules));

multiRules =
  # Case-sensitive rules that match more complex conditions.
  rules: (lib.listToAttrs (map (rule: lib.nameValuePair rule.name {
    name = rule.name;
    enabled = true;

    action = "allow";
    duration = "always";

    operator = {
      type = "list";
      operand = "list";

      list = map (lib.mergeAttrs { sensitive = true; }) rule.list;
    };
  }) rules));
in {
  modules.opensnitch.nixos = {config, pkgs, ...}:
  let hm = config.home-manager.users.${config.stgs.user.name}; in {
    services.opensnitch = {
      enable = true;
      settings.ProcMonitorMethod = "ebpf";

      rules = lib.mkMerge [
        # Simple rules that match on the path of the executable.
        (simpleRules [
          { name = "dhcpcd"; data = "${pkgs.dhcpcd}/bin/dhcpcd"; }
          { name = "nsncd"; data = "${pkgs.nsncd}/bin/nsncd"; }
          { name = "mullvad-daemon"; data = "${pkgs.mullvad}/bin/.mullvad-daemon-wrapped"; }
        ])

        (multiRules
          [
            {
              name = "librewolf";
              list = [
                (genRule "regexp" "process.path" "^/nix/store/[0-9a-z]{32}-librewolf-.*/lib/librewolf/librewolf")
                (genRule "simple" "process.command" "/usr/bin/librewolf")
              ];
            }

            {
              name = "systemd-timesyncd";
              list = [
                (genRule "regexp" "dest.host" "\\d\\.nixos\\.pool\\.ntp\\.org")
                (genRule "simple" "process.path" "${pkgs.systemd}/lib/systemd/systemd-timesyncd")
              ];
            }

            {
              name = "kworker-wg";
              list = [
                (genRule "simple" "dest.port" "51820")
                (genRule "simple" "user.id" "0")
                (genRule "simple" "process.path" "Kernel connection")
              ];
            }

            {
              name = "flatpak-to-flathub";
              list = [
                (genRule "simple" "process.path" "${pkgs.flatpak}/bin/.flatpak-wrapped")
                (genRule "simple" "dest.host" "dl.flathub.org")
              ];
            }
          ])
      ];
    };
  };

  modules.opensnitch.home = {pkgs, ...}: {
    home.packages = [ pkgs.opensnitch-ui ];

    # Opensnitch-ui provides the network request popups.
    services.opensnitch-ui.enable = true;

    systemd.user.services.opensnitch-ui.Service = {
      MemoryHigh = "70M";
      MemoryAccounting = true;
    };
  };
}
