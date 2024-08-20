{
  description = "Home Manager configuration of user";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url  = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: remove this and add a pelz template for gtk themeing
    gruvbox-material-gtk = {
      url = "github:oxcl/gruvbox-material-gtk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my custom font
    iozevka = {
      url = "github:oxcl/iozevka";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager,... }@inputs :
  let
      system = "x86_64-linux";
      overlays = [
        inputs.iozevka.overlays.default
        inputs.gruvbox-material-gtk.overlays.default
      ];
      pkgs = import nixpkgs { 
        inherit system overlays;
        config.allowUnfree = true;
      };
      unstable = import inputs.unstable {
        inherit system;
        config.allowUnfree = true;
      };
      mkSystem = name: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs unstable; };
        modules = [
          ./systems/base.nix
          ./systems/${name}/configuration.nix
          ({...}: { networking.hostName = name; })
        ];
      };
      mkHome = name: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs unstable; };
        modules = [ ./profiles/${name}.nix ];
      };
  in {
    nixosConfigurations = {
      machine = mkSystem "machine"; # for bare-metal
    };
    homeConfigurations = {
      base = mkHome "base";
      dev  = mkHome "dev";
      full = mkHome "full";
    };
  };
}
