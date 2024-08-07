{ config, pkgs, unstable,inputs, ... }: with builtins;
{
  home.username = "user";
  home.homeDirectory = "/home/user";

  programs.firefox = {
    enable = true;
    package = unstable.firefox-bin;
    policies = (fromJSON (readFile ./policies.json)).policies;
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
    rar
    emacs-all-the-icons-fonts
    ((emacsPackagesFor emacs29).emacsWithPackages ( epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
      vterm
    ]))
    direnv
    bitwarden-cli
    glow
    pv
    thefuck
    expect
    fzf
    asciinema
    asciinema-agg
    gifsicle
    htop
    tldr
    python3
    python312Packages.pip
  ];

  # enable dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
