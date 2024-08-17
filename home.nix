{ config, pkgs, unstable,lib,inputs, ... }: with builtins;
{
  home.username = "user";
  home.homeDirectory = "/home/user";

  programs.firefox = let
  # add extensions you want to install here.
  extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
    tridactyl
    darkreader
    ublock-origin
  ];
  extensionDefaults = {
    "*" = {
      updates_disabled = true;
      installation_mode = "blocked";
    };
  };
  extensionPolicy = {
    ExtensionSettings = extensionDefaults // builtins.listToAttrs (map (extension: {
      name = extension.addonId;
      value = {
        default_area = "navbar";
        updates_disabled = true;
        installation_mode = "force_installed";
        install_url = extension.src.url;
      };
    }) extensions); 
  };
  in {
    enable = true;
    package = unstable.firefox-bin;
    policies = (fromJSON (readFile ./policies.json)).policies // extensionPolicy;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
    };
  };

  home.packages = with pkgs; [
    git
    stow # for .dotfiles management
    lsd # ls alternative with icons
    lsix # display images in the terminal with sixel graphics
    iozevka
    iozevka-nerd
    wl-clipboard # cli clipboard utility for wayland
    bat # alternative to cat with syntax-highlighting 
    jq # json parser
    pup # html parser
    p7zip
    zip
    unzip
    rar
    emacs-all-the-icons-fonts
    ((emacsPackagesFor emacs29).emacsWithPackages ( epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
      vterm
    ]))
    direnv
    bitwarden-cli
    glow # marakdown preview
    pv # control pipes. used to create typewriter effect in terminal
    thefuck
    expect
    fzf
    asciinema # record terminal window
    asciinema-agg # convert asciinema casts to gifs
    gifsicle # compress gifs
    htop
    tldr
    python3
    python312Packages.pip
    gruvbox-material-gtk
    vazir-fonts # farsi and arabic font
    vazir-code-font # farsi and arabic monospace
    jetbrains-mono
    noto-fonts # last resort font
    foot
    rofi-wayland
    woof # open a http server for uploading to current directory. used in .local/bin/serve
    aria2 # cli download manager
    gtrash
  ];

  # enable dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.activation = {
    # automatically run my stow script to setup dotfiles in home directory after every home-manager/nixos rebuild
    stowHome = lib.hm.dag.entryAfter ["writeBoundary"] ''[ -f $HOME/.local/bin/stowhome ] && PATH="$PATH:${pkgs.stow}/bin" $HOME/.local/bin/stowhome'';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
