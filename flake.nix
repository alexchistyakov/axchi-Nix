{
  description = "AxchiOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";

    hyprland = {
      url = "github:hyprwm/Hyprland/main";
    };
    hyprland-qt-support = {
      url = "github:hyprwm/hyprland-qt-support";
    };  
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, hyprland, hyprland-qt-support, ... }@inputs:
    let
      system = "nixos";
      host = "axchi-nix-desktop";
      username = "axchi";
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    with pkgs;
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
	    inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ({ config, ... }: {
              nixpkgs.config = {
                allowUnfree = true;
              };
            })
            ./hosts/${host}/config.nix
            inputs.stylix.nixosModules.stylix
            hyprland.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
              };
              #home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./config/core/home.nix;
            }
          ];
        };
      devShells.x86_64-linux.default = mkShell {
        buildInputs = [
          cargo
          rustc
          SDL2
          alsa-lib.dev
          code-cursor
          pkg-config
        ];

        shellHook = ''
          export PKG_CONFIG_PATH=${pkgs.alsa-lib.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
        '';
      };      
    };
  };
}