{
  description = "My NixOS Flake";

  inputs = {
    # NixOS 25.05 for the system
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # provide Unstable for testing
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

#     nixpkgs-locked.url = "github:NixOS/nixpkgs/commit_sha";
    nixpkgs-locked.url = "github:NixOS/nixpkgs/d9bc5c7dceb30d8d6fafa10aeb6aa8a48c218454";
#     nixpkgs-unstable-locked.url = "github:NixOS/nixpkgs/commit_sha";
    nixpkgs-unstable-locked.url = "github:NixOS/nixpkgs/a672be65651c80d3f592a89b3945466584a22069";
    ## add to inputs
    SumContext.url = "github:SumContext/sumtree";

    home-manager = {
      url = "github:nix-community/home-manager";
      # IMPORTANT: Make home-manager use your UNSTABLE nixpkgs for user packages
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
# date +"%Y-%m-%d %H:%M:%S" && git ls-remote https://github.com/NixOS/nixpkgs.git refs/heads/nixos-25.11 && git ls-remote https://github.com/NixOS/nixpkgs.git refs/heads/nixpkgs-unstable
# 2025-12-07 13:50:02
# d9bc5c7dceb30d8d6fafa10aeb6aa8a48c218454        refs/heads/nixos-25.11
# a672be65651c80d3f592a89b3945466584a22069        refs/heads/nixpkgs-unstable

  outputs = {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-locked,
      nixpkgs-unstable-locked,
      home-manager,
      ...
    }@inputs: {

    # --- OUTPUT 1: YOUR NIXOS SYSTEM CONFIGURATION ---
#     nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem { #MajorTom
      system = "x86_64-linux";
      specialArgs = {
        # Pass unstable pkgs to configuration.nix if needed for system packages
        locked = nixpkgs-locked.legacyPackages."x86_64-linux";
        unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
        unstablelocked = nixpkgs-unstable-locked.legacyPackages."x86_64-linux";
      };

      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        # DO NOT include home-manager's NixOS module here anymore.
      ];
    };

    # --- OUTPUT 2: YOUR STANDALONE HOME MANAGER CONFIGURATION ---
    homeConfigurations."owner" = home-manager.lib.homeManagerConfiguration {
#       pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Use unstable for user pkgs
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  extraSpecialArgs = {
    locked = import nixpkgs-locked {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    unstablelocked = import nixpkgs-unstable-locked {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };
      modules = [
        # The path to your user-specific configuration
        ./home.nix
      ];
    };#home manager end

  };
}
