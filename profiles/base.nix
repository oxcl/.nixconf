{ config, pkgs, unstable,lib,inputs, ... }: with builtins;

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.packages = with pkgs; [
    git
    stow # for .dotfiles management
    lsd # ls alternative with icons
    htop
    python3
    python312Packages.pip
    gtrash # cli trash (replaces rm in zsh)
    ripgrep
    openssh
    bat # alternative to cat with syntax-highlighting
    jq # json parser
    direnv
  ];

  home.activation = {
    # automatically run my stow script to setup dotfiles in home directory after every home-manager/nixos rebuild
    stowHome = lib.hm.dag.entryAfter ["writeBoundary"] ''[ -f $HOME/.local/bin/stowhome ] && PATH="$PATH:${pkgs.stow}/bin" $HOME/.local/bin/stowhome'';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
