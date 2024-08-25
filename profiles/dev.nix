{ config, pkgs, unstable,lib,inputs, ... }: with builtins;

{
  imports = [ ./base.nix ];
  home.packages = with pkgs; [
    lsix # display images in the terminal with sixel graphics
    wl-clipboard # cli clipboard utility for wayland
    pup # html parser (required for xiny scripts)
    emacs-all-the-icons-fonts
    ((emacsPackagesFor emacs29).emacsWithPackages ( epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
      vterm
      jinx
    ]))
    glow # marakdown preview
    thefuck
    expect
    fzf
    tldr
    qrencode
    whois
    jetbrains-mono # fallback for iozevka
    # spell checkers for emacs
    aspell
    aspellDicts.en
    aspellDicts.de
    aspellDicts.fa
    hunspell
    hunspellDicts.en-us
    hunspellDicts.de-de
    hunspellDicts.fa-ir
  ];
}
