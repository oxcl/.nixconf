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
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.machine = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./configuration.nix ];
      };
      homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
