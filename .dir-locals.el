((nil .
      ((eglot-workspace-configuration
        . (:nixd
           (:options ( :nixos
                       (:expr "(builtins.getFlake (builtins.toString ./. )).nixosConfigurations.main.options")
                       :hm
                       (:expr "(builtins.getFlake (builtins.toString ./. )).nixosConfigurations.main.options.home-manager.users.type.getSubOptions []")
                       )
            :eval (:target (:args ["--offline"]))))))))
