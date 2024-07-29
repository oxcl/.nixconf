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

  };

  outputs = { nixpkgs, home-manager,... }@inputs :
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { 
        inherit system;
        config.allowUnfree = true;
      };
      unstable = import inputs.unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.machine = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs unstable; };
        modules = [ ./configuration.nix ];
      };
      homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs unstable; };
        modules = [ ./home.nix ];
      };
    };
}
