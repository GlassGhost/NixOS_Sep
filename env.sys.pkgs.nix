#{ pkgs, ... }:
{ pkgs, unstable, ... }: 

{  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
######################################################################


    # https://nixos.wiki/wiki/Development_environment_with_nix-shell
    #mach-nix
    #bash-interactive
    #gcc-wrapper
    #stdenv-linux
    #gccStdenv
    #libcxxStdenv
    #jupyter notebook still need mach nix and requirements
    #ihaskell 
    #jupyter
    #python39Packages.jupyter_core
    #python310
######################################################################

    #gnome-terminal

################################################################################
# (matePackages.pluma.overrideAttrs (_: { meta.broken = true; })) # Disable pluma

    #(import /home/owner/sync/pepsi.nix)
    #(import /home/owner/sturdy-adventure/libbf.nix)
    #(import /home/owner/sync/pepsi2.nix)
    
    # basic computer software
    # Nano editor is also installed by default.
    #unstable.webcord #comment out if you don't have unstable

    # hunspell crap
    #hunspell
    #hunspellDicts.en_US
    #hunspellDicts.en-us
    #hunspellDicts.en_US-large
    #hunspellDicts.en-us-large
    #hunspellDicts.en-gb-large
    #hunspellDicts.en_GB-large


  ];
  }


################################################################################

#   ];
#   }
# 
# 
# #{ config, ... }:    
# #{
# #  imports =
# #    [ # Include the results of the hardware scan.
# #      ./hardware-configuration.nix
# #      # Include the package list.
# #      ./env.sys.pkgs.nix
# #    ];
# #  # SOME STUFF
# #  # SOME STUFF
# #}
# 
# { pkgs, ... }:
# {
#   environment.systemPackages = with pkgs; [
# # add this file to /etc/nixos/ directory and add ./env.sys.pkgs.nix to imports
# # in conf.nix as above
# 
# ################################################################################
# 
#   # List packages installed in system profile. To search, run:
#   # $ nix search nameOFsomepkg
# 
#   ];
# }

