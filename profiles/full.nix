{ config, pkgs, unstable,lib,inputs, ... }: with builtins;

{
  imports = [ ./dev.nix ];
  programs.firefox =
  let
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
    policies = (fromJSON (readFile ../policies.json)).policies // extensionPolicy;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
    };
  };

  home.packages = with pkgs; [
    p7zip
    zip
    unzip
    rar
    bitwarden-cli
    asciinema # record terminal window
    asciinema-agg # convert asciinema casts to gifs
    gifsicle # compress gifs
    gruvbox-material-gtk
    vazir-fonts # farsi and arabic font
    vazir-code-font # farsi and arabic monospace
    iozevka # my custom font
    iozevka-nerd
    noto-fonts # last resort font
    foot
    rofi-wayland
    woof # open a http server for uploading to current directory. used in .local/bin/serve
    aria2 # cli download manager
    vlc
  ];


  systemd.user.enable = true;
  systemd.user.services = {
    user-scripts = {
      Unit.Description = "local server hosting user scripts and other files used by firefox";
      Service = {
        ExecStart = "%h/.local/bin/user-scripts";
        Environment = "PATH=${with pkgs; lib.makeBinPath [ python3 bash] }";
        Restart = "on-failure";
      };
      Install.WantedBy = ["default.target"];
    };
  };

}
