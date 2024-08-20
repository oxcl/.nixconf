{ config, pkgs, unstable, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  # login display manager
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "user";
    };
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  # window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # login without sudo
  security.sudo.wheelNeedsPassword = false;


  # hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # enable sound in wayland
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

}
