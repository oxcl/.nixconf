{ config, pkgs, unstable,inputs, ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };

  programs.chromium.enable = true;

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
    ((emacsPackagesFor emacs29).emacsWithPackages ( epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
    ]))
    direnv
    bitwarden-cli
    glow
    pv
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
