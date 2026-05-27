{...}: {
  modules.librewolf.home = {pkgs, inputs, ...}: {
    programs.librewolf = {
      enable = true;
      package = pkgs.mkBwrapper {
        imports = [ pkgs.bwrapperPresets.desktop ];
        app = {
          package = pkgs.librewolf;
          runScript = "librewolf";
        };
        sockets.x11 = false;
        mounts.readWrite = [ "$HOME/.librewolf" ];
      };

      profiles.default = {
        isDefault = true;

        # 'about:config' settings should be set here since they can be ignored
        # when set globally.
        settings = {
          "browser.tabs.inTitlebar" = 2;
          "browser.toolbars.bookmarks.visibility" = "never";

          "sidebar.verticalTabs" = false;
          "sidebar.visibility" = "hide-sidebar";

          "webgl.disabled" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          "privacy.resistFingerprinting.letterboxing" = true;
          "extensions.autoDisableScopes" = 0;
        };

        extensions.packages =
          with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin
            canvasblocker
            tridactyl
            localcdn
            umatrix
            auto-tab-discard
            libredirect
          ];

        # Override minimum window size.
        userChrome = "html { min-width: 0 !important; }";

        bookmarks = {
          force = true;

          settings = [
            # Logic games practice.
            { name = "Syllogimous V4";
            url  = "https://4skinskywalker.github.io/Syllogimous-v4/Intro";
            }

            # Reading to do.
            { name = "Kahne: Multiple Mentality";
            url  = "http://www.rexresearch.com/kahne/kahne.htm";
            }

            # Internship programs.
            { name = "CMU Research Internships";
            url  = "https://www.cmu.edu/scs/s3d/reuse/Research/index.html";
            }

            # Interesting guides to build personal projects.
            {
              name = "Build your own X";
              url = "https://github.com/codecrafters-io/build-your-own-x";
            }
          ];
        };
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # Set librewolf as the default browser.
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
      };
    };
  };
}
