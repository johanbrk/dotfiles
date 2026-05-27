{pkgs, rootPath, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system
      /${rootPath}/system/impermanence.nix
      /${rootPath}/system/systemd-hardening.nix
    ];

  # Enable flakes.
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/persistent/passwords/root";
  users.users.johannes.hashedPasswordFile = "/persistent/passwords/root";

  # Enable earlyoom to prevent freezes.
  services.earlyoom.enable = true;

  boot.kernel.sysctl = {
    "vm.swappiness" = 200;
    "vm.vfs_cache_pressure" = 200;
    "kernel.sysrq" = 1;
  };

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flake = "github:JohannesBarjak/dotfiles#main";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;

  boot.kernelParams = [ "acpi_backlight=native" "quiet" "loglevel=3" ];
  boot.kernelPackages = pkgs.linuxPackages_6_18; # Temporarily fix to 6.18 to prevent opensnitchd bug.
  boot.supportedFilesystems = [ "ntfs" ];

  boot.initrd.systemd.enable = true;

  boot.plymouth = {
    enable = true;

    theme = "cross_hud";
    themePackages = with pkgs; [ (adi1090x-plymouth-themes.override { selected_themes = [ "cross_hud" ]; }) ];
  };

  fileSystems."/".options = [ "compress-force=zstd:-5" "noatime" ];

  # Enable graphics.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  #Enable bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  hardware.enableAllFirmware = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johannes = {
    isNormalUser = true;
    description = "Johannes";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wl-clipboard glib

    ryzenadj
    compsize

    gcc # Added to the global path to permit the install of tree-sitter grammars.
  ];

  hardware.cpu.amd.ryzen-smu.enable = true; # Enable system management driver for Amd.
  hardware.amdgpu.overdrive.enable = false; # Enable gpu overclock capabilities.
  programs.corectrl.enable = true;          # Enable corectl. It provies an inteface for chip configuration.

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-medium.yaml";
  stylix.opacity.popups = 0.85;
  stylix.opacity.terminal = 0.85;

  stylix.targets.plymouth.enable = false;

  environment.sessionVariables = {
    TERMINAL = "kitty";

    # Qt related environment variables.
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORM = "wayland";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.

  virtualisation.containers.enable = true;

  virtualisation.vmVariant = {
    virtualisation.memorySize = 4096;

    # Taken from https://github.com/donovanglover/nix-config/commit/0bf134297b3a62da62f9ee16439d6da995d3fbff
    # to enable wayland to work on a virtualized GPU.
    virtualisation.qemu.options = [
      "-device virtio-vga-gl"
      "-display gtk,gl=on,grab-on-hover=on,window-close=off"
      # Wire up pipewire audio
      "-audiodev pipewire,id=audio0"
      "-device intel-hda"
      "-device hda-output,audiodev=audio0"
    ];
  };

  # Configure fonts.
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      nerd-fonts.fira-code
      nerd-fonts.cousine
      nerd-fonts.caskaydia-mono
    ];

    fontconfig.enable = true;

    fontconfig = {
      # Enable font hinting.
      hinting = {
        enable = true;
        style = "full";
      };

      antialias = true;

      subpixel.rgba = "rgb";
    };
  };

  # List services that you want to enable:

  services.udisks2.enable = true;

  security.polkit.enable = true;
  security.sudo-rs.enable = true;

  services.locate.enable = true; # Scans filesystem for file searching.

  # Switch to a faster dbus implementation.
  services.dbus.implementation = "broker";

  services.journald.extraConfig = "SystemMaxUse=50M";

  stgs.user.name = "johannes";
  stgs.user.wm = "mango";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
