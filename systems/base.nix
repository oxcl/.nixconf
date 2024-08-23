# base configuration that should be applied to all nixos systems
{ config, pkgs, unstable, inputs, host, ... }:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  networking.hostName = host;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tehran";
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
   layout = "us,ir(pes_keypad)";
   options = "grp:win_space_toggle";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  # Define a user account.
  users.users.user = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 433    # HTTP & HTTPS
      8000 8001 # my ~/.local/bin/serve script
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
