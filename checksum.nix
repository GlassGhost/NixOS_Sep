{
  description = "My NixOS Flake";

  inputs = {

# date +"%Y-%m-%d %H:%M:%S" && git ls-remote https://github.com/NixOS/nixpkgs.git refs/heads/nixos-25.05 && git ls-remote https://github.com/NixOS/nixpkgs.git refs/heads/nixpkgs-unstable
# 2025-10-24 04:23:29
# 481cf557888e05d3128a76f14c76397b7d7cc869        refs/heads/nixos-25.05
# d5faa84122bc0a1fd5d378492efce4e289f8eac1        refs/heads/nixpkgs-unstable

    # NixOS 25.05 for the system
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

#     nixpkgs-locked.url = "github:NixOS/nixpkgs/commit_sha";
    nixpkgs-locked.url = "github:NixOS/nixpkgs/481cf557888e05d3128a76f14c76397b7d7cc869";

    # NixOS Unstable for user packages (can be updated separately)
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

#     nixpkgs-unstable-locked.url = "github:NixOS/nixpkgs/commit_sha";
    nixpkgs-unstable-locked.url = "github:NixOS/nixpkgs/d5faa84122bc0a1fd5d378492efce4e289f8eac1";

    home-manager = {
      url = "github:nix-community/home-manager";
      # IMPORTANT: Make home-manager use your UNSTABLE nixpkgs for user packages
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

#   outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {

  outputs = {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs: {
      # --- OUTPUT 1: YOUR NIXOS SYSTEM CONFIGURATION ---
      #     nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
        # MajorTom
        system = "x86_64-linux";
        specialArgs = {
          # Pass unstable pkgs to configuration.nix if needed for system packages
          unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
        };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          {
            nixpkgs.overlays = [
              (_final: _prev: {
                locked = import inputs.nixpkgs-locked {
                  inherit system;
                };
              })
            ];
          }
          # DO NOT include home-manager's NixOS module here anymore.
        ];
      };


    };
}