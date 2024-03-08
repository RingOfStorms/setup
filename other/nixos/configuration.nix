# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# FOR HOME MANAGER: https://nix-community.github.io/home-manager/options.xhtml

# Flakes config
# https://youtu.be/ACybVzRvDhs?si=EbGmfUde8QLbaHKx&t=430

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
    # to get hash run `nix-prefetch-url --unpack "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz"`
    sha256 = "0562y8awclss9k4wk3l4akw0bymns14sfy2q9n23j27m68ywpdkh";
  };
  # TODO update to be in this config normally
  weztermConfig = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/RingOfStorms/setup/72635c6674540bfefa2325f69e6ee6de9a11a62b/home/dotfiles/wezterm.lua";
    sha256 = "sha256-kwbg9S9IHhAw6RTPvRjqGew5qz8a8VxjqonkgEKGtys=";
  };
in

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./stupid-keyboard.nix
      (import "${home-manager}/nixos")
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # for home manager
  security.polkit.enable = true;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "keep";
    };
    timeout = 5;
    efi = {
      canTouchEfiVariables = true;
    };
  };
  boot.kernelParams = [
    # The GPD Pocket3 uses a tablet OLED display, that is mounted rotated 90° counter-clockwise
    "video=DSI-1:panel_orientation=right_side_up"
    "fbcon=rotate:1"
    "mem_sleep_default=s2idel"
    "fbcon=rotate:1"
    "video=DSI-1:panel_orientation=right_side_up"
  ];

  networking.hostName = "gpdPocket3";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  # Necessary kernel modules
  boot.kernelModules = [ "btusb" ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "thunderbolt" ];
  services.xserver.videoDrivers = [ "intel" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
  ];

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

  # I want this globally even for root so doing it outside of home manager
  services.xserver.xkbOptions = "caps:escape";

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    useXkbConfig = true; # use xkb.options in tty. (caps -> escape)
  };

  # Attempting to get fingerprint scanner to work... having issues though
  #services.fwupd.enable = true;
  #services.fprintd = {
  #  enable = true;
  #  package = pkgs.fprintd-tod;
  #  tod.enable = true;
  #  tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  #  #tod.driver = pkgs.libfprint-2-tod1-goodix;
  #};

  hardware.enableAllFirmware = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  users.users.root.initialPassword = "password1";
  users.users.josh = {
    initialPassword = "password1";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  home-manager.users.josh = { pkgs, ... }: {
    programs.home-manager.enable = true;
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";

    home.packages = with pkgs; [
      firefox-esr
      wezterm
      vivaldi
      ollama

      # Desktop Environment stuff
      wofi # app launcher TODO configure this somehow
      gnome.dconf-editor # use `dump dconf /` before and after and diff the files for easy editing of dconf below
      gnomeExtensions.workspace-switch-wraparound
      #gnome.gnome-tweaks
      #gnomeExtensions.forge # probably dont need on this on tiny laptop but may explore this instead of sway for my desktop
    ];

    home.file.".wezterm.lua".source = weztermConfig; # todo actual configure this in nix instead of pulling from existing one. Maybe lookup the more official home manager dotfile solutions instead of inline
    home.file.".psqlrc".text = ''
      \pset pager off
    '';
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
    };
    programs.tmux = {
      enable = true;
    };
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        workspaces = true;
        exit-mode = "return-query";
        enter_accept = true;
      };
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        palette = "catppuccin_coal";
        palettes.catppuccin_coal = import ./catppuccin_coal.nix;
      };
    };

    dconf = {
      enable = true;
      settings = import ./gnome_settings.nix { inherit pkgs; };
    };

    gtk = {
      enable = true;

      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };

      gtk3.extraConfig = {
        Settings = ''
          	gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          	gtk-application-prefer-dark-theme=1
        '';
      };
    };

    home.sessionVariables.GTK_THEME = "palenight";

  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-utilities.enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Basics
    neovim
    vim
    wget
    curl
    neofetch
    bat
    htop
    nvtop
    unzip
    git
    # [Laptop] Battery status
    acpi
    # extras
    cargo
    rustc
    nodejs_21
    python313
    ripgrep
    nodePackages.cspell
  ];

  programs.zsh = {
    enable = true;
  };
  # does for all shells. Can use `programs.zsh.shellAliases` for specific ones
  environment.shellAliases = {
    n = "nvim";
    battery = "acpi";
    wifi = "nmtui";
    bat = "bat --theme Coldark-Dark";
    cat = "bat --pager=never -p";
    nix-boot-clean = "find '/boot/loader/entries' -type f | head -n -4 | xargs -I {} rm {}; nix-collect-garbage -d; nixos-rebuild boot; echo; df";
    nix-upgrade = "nixos-rebuilt switch --upgrade";

  };

  # [Laptop] screens with brightness settings
  programs.light.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Most users should NEVER change this value after the initial install, for any reason
  system.stateVersion = "23.11"; # Did you read the comment?
}
