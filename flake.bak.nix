{
  description = "My NixOS Flake";

  inputs = {
    # NixOS 25.05 for the system
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # NixOS Unstable for user packages (can be updated separately)
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      # IMPORTANT: Make home-manager use your UNSTABLE nixpkgs for user packages
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {
    # --- OUTPUT 1: YOUR NIXOS SYSTEM CONFIGURATION ---
#     nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem { #MajorTom
      system = "x86_64-linux";
      specialArgs = {
        # Pass unstable pkgs to configuration.nix if needed for system packages
        unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
      };
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        # DO NOT include home-manager's NixOS module here anymore.
      ];
    };

    # --- OUTPUT 2: YOUR STANDALONE HOME MANAGER CONFIGURATION ---
    homeConfigurations."owner" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs-unstable.legacyPackages."x86_64-linux"; # Use unstable for user pkgs
#       pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Use unstable for user pkgs
      extraSpecialArgs = {
        # You can still pass arguments if home.nix needs them
        # For instance, if you wanted to access stable pkgs too:
        stable-pkgs = nixpkgs.legacyPackages."x86_64-linux";
#         unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
      };
      modules = [
        # The path to your user-specific configuration
        ./home.nix
      ];
    };#home manager end

  };
}
