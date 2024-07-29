{ config, pkgs, unstable,inputs, ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };

  programs.emacs.enable = true;
  programs.git.enable = true;
  programs.chromium.enable = true;

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
