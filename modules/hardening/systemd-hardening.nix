{...}: {
  modules.systemd-hardening.nixos = {lib, ...}: let
    protectKernel = enabled: {
      ProtectKernelTunables = enabled;
      ProtectKernelLogs = enabled;
      ProtectKernelModules = enabled;
      ProtectControlGroups = enabled;
    };

    protectFilesystem =
      ProtectSystem: ProtectHome: PrivateTmp: ReadWritePaths: {
        inherit ProtectSystem ProtectHome PrivateTmp ReadWritePaths;
      };

    privilegeEscalation = enabled: {
      NoNewPrivileges = enabled;
      RestrictSUIDSGID = enabled;
      LockPersonality = enabled;
      RestrictRealtime = enabled;
    };

    protectDevices = enabled: full: {
      PrivateDevices = full;
      ProtectClock = enabled;
    };
    protectNetwork = enabled: private: {
      ProtectHostname = enabled;
      PrivateNetwork = private;
    };
  in {
    systemd.services = {
      cups.serviceConfig = lib.mkMerge [
        (protectKernel true)
        (protectFilesystem "strict" true true
          [ "-/var/spool/cups" "-/var/cache/cups" "-/var/lib/cups" "-/run/cups" ])
        (privilegeEscalation true)
        (protectDevices true false)
        (protectNetwork true true)
        { RestrictNamespaces = true; }
      ];

      cups-browsed.serviceConfig = lib.mkMerge [
        (protectKernel true)
        (protectFilesystem "strict" true true
          [ "-/var/cache/cups" "-/var/log/cups" ])
        (privilegeEscalation true)
        (protectDevices true true)
        (protectNetwork true false)
        { RestrictNamespaces = true; }
      ];
    };
  };
}
