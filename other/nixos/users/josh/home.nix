{ pkgs, settings, ... } @ args:
let
  # TODO update to be in this config normally
  weztermConfig = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/RingOfStorms/setup/72635c6674540bfefa2325f69e6ee6de9a11a62b/home/dotfiles/wezterm.lua";
    sha256 = "sha256-kwbg9S9IHhAw6RTPvRjqGew5qz8a8VxjqonkgEKGtys=";
  };
in
{
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
      palettes.catppuccin_coal = import "${settings.commonDir}/catppuccin_coal.nix";
    };
  };

  dconf = {
    enable = true;
    settings = (import ./gnome_settings.nix args);
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

}
