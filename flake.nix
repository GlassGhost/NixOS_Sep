{
  description = "My NixOS Flake";

  inputs = {
    # NixOS 25.05 for the system
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # provide Unstable for testing
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

#     nixpkgs-locked.url = "github:NixOS/nixpkgs/commit_sha";
    nixpkgs-locked.url = "github:NixOS/nixpkgs/76701a179d3a98b07653e2b0409847499b2a07d3";
#     nixpkgs-unstable-locked.url = "github:NixOS/nixpkgs/commit_sha";
    nixpkgs-unstable-locked.url = "github:NixOS/nixpkgs/8142186f001295e5a3239f485c8a49bf2de2695a";
    ## add to inputs
    SumContext.url = "github:SumContext/sumtree/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      # IMPORTANT: Make home-manager use your UNSTABLE nixpkgs for user packages
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
# date +"%Y-%m-%d %H:%M:%S" && git ls-remote https://github.com/NixOS/nixpkgs.git refs/heads/nixos-25.11 && git ls-remote https://github.com/NixOS/nixpkgs.git refs/heads/nixpkgs-unstable
# 2025-12-24 11:35:29
# 76701a179d3a98b07653e2b0409847499b2a07d3        refs/heads/nixos-25.11
# 8142186f001295e5a3239f485c8a49bf2de2695a        refs/heads/nixpkgs-unstable

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
          inherit (inputs) SumContext;

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
          ./configuration.nix
          ./hardware-configuration.nix

          # Add this inline module
          {
            nixpkgs.overlays = [
              (final: prev: {
                n8n = prev.n8n.overrideAttrs (old: {
                  buildPhase = ''
                    export NODE_OPTIONS="--max-old-space-size=8192"
                    ${old.buildPhase}
                  '';
                });
              })
            ];
          }
        ];

#       modules = [
#         ./configuration.nix
#         ./hardware-configuration.nix
# #         {
# #           nixpkgs.config.allowUnfree = true;
# #         }
#         # DO NOT include home-manager's NixOS module here anymore.
#       ];
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
