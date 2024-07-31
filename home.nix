{ config, pkgs, unstable,inputs, ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };

  programs.emacs.enable = true;
  programs.chromium.enable = true;

  home.packages = with pkgs; [
    git
    stow # for .dotfiles management
    lsd # ls alternative with icons
    iozevka
    iozevka-nerd
    wl-clipboard # cli clipboard utility for wayland
    bat # alternative to cat with syntax-highlighting 
    jq # json parser
    pup # html parser
    p7zip
    zip
    rar
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
