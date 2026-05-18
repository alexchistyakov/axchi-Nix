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
      username = "axchi";
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      hosts = [
        "axchi-nix-desktop"
        "axchi-nix-laptop"
      ];

      mkHost = host: nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs username host;
        };
        modules = [
          ({ ... }: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/${host}/config.nix
          inputs.stylix.nixosModules.stylix
          hyprland.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit username inputs host;
            };
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./config/core/home.nix;
          }
        ];
      };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
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
}
