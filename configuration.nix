
########################################################################
# this file should be saved in /etc/nixos/configuration.nix
# edit with:
# sudo gedit /etc/nixos/configuration.nix
# update system with:
# sudo nixos-rebuild switch
# remember to back up this file everytime you edit it
########################################################################
# {config, pkgs, ...}: {
# { config, inputs, pkgs, nixpkgs-unstable, ... }:
{ config, pkgs, unstable, locked, unstablelocked, SumContext, ... }:
# { config, pkgs, unstable, ... }:

#     SumContext.url = "github:SumContext/sumtree";

let
#   pypi2nix = import (pkgs.fetchgit {
#     url = "https://github.com/nix-community/pypi2nix";
#     # adjust rev and sha256 to desired version
#     rev = "v2.0.1";
#     sha256 = "sha256:0mxh3x8bck3axdfi9vh9mz1m3zvmzqkcgy6gxp8f9hhs6qg5146y";
#   }) {};
#   unstable = import <nixpkgs-unstable> {
#     config = config.nixpkgs.config;      # include unfree & other global settings
#   };

##### uv
  inherit (pkgs) lib;

  # --- pyproject-nix ---
  pyproject-nix-src = builtins.fetchGit {
    url = "https://github.com/pyproject-nix/pyproject.nix.git";
    rev = "84c4ea102127c77058ea1ed7be7300261fafc7d2";
  };
  pyproject-nix = pkgs.stdenv.mkDerivation {
    pname = "pyproject-nix";
    version = "unstable-2025-10-24";
    src = pyproject-nix-src;
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
  };

  # --- uv2nix ---
  uv2nix-src = builtins.fetchGit {
    url = "https://github.com/pyproject-nix/uv2nix.git";
    rev = "e6e728d9719e989c93e65145fe3f9e0c65a021a2";
  };
  uv2nix = pkgs.stdenv.mkDerivation {
    pname = "uv2nix";
    version = "unstable-2025-10-24";
    src = uv2nix-src;
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
  };

  # --- pyproject-build-systems ---
  pyproject-build-systems-src = builtins.fetchGit {
    url = "https://github.com/pyproject-nix/build-system-pkgs.git";
    rev = "dbfc0483b5952c6b86e36f8b3afeb9dde30ea4b5";
  };
  pyproject-build-systems = pkgs.stdenv.mkDerivation {
    pname = "pyproject-build-systems";
    version = "unstable-2025-10-24";
    src = pyproject-build-systems-src;
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
  };

# echo hi
# nix-store --query --requisites /run/current-system | grep pyproject
# nix-store --query --requisites /run/current-system | grep uv2nix
# nix-store --query --requisites /run/current-system | grep pyproject-build-systems
# 
# nix-store --query --tree 
# nix-store --query --tree /nix/store/8msqa29yazvs4qmiwz3c0139gw36xlnb-pyproject-nix-unstable-2025-10-24
# nix-store --query --tree /nix/store/naa4dnnxh07ynbs13a1k2w6h4gdrix9n-uv2nix-unstable-2025-10-24


#   pyproject-nix = import (builtins.fetchGit {
#     url = "https://github.com/pyproject-nix/pyproject.nix.git";
#     rev = "84c4ea102127c77058ea1ed7be7300261fafc7d2";
#   }) {
#     inherit lib;
#   };
# 
#   uv2nix = import (builtins.fetchGit {
#     url = "https://github.com/pyproject-nix/uv2nix.git";
#     rev = "e6e728d9719e989c93e65145fe3f9e0c65a021a2";
#   }) {
#     inherit pyproject-nix lib;
#   };
# 
#   pyproject-build-systems = import (builtins.fetchGit {
#     url = "https://github.com/pyproject-nix/build-system-pkgs.git";
#     rev = "dbfc0483b5952c6b86e36f8b3afeb9dde30ea4b5";
#   }) {
#     inherit pyproject-nix uv2nix lib;
#   };
######
# date +"%Y-%m-%d %H:%M:%S" \
#   && git ls-remote https://github.com/pyproject-nix/pyproject.nix.git refs/heads/master \
#   && git ls-remote https://github.com/pyproject-nix/uv2nix.git refs/heads/master \
#   && git ls-remote https://github.com/pyproject-nix/build-system-pkgs.git refs/heads/master
# 2025-10-24 11:10:51
# 84c4ea102127c77058ea1ed7be7300261fafc7d2        refs/heads/master
# e6e728d9719e989c93e65145fe3f9e0c65a021a2        refs/heads/master
# dbfc0483b5952c6b86e36f8b3afeb9dde30ea4b5        refs/heads/master

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include the package list.
      # (import ./env.sys.pkgs.nix { pkgs = pkgs; unstable = unstable; })
    ];

# https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone

  # Enable Flakes https://youtu.be/JCeYq72Sko0
  #nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Enable systemd in initrd
  boot.initrd.systemd.enable = true;
########################################################################

environment.systemPackages = with pkgs; [
#     pkgs.curl # provided by busybox for full list of pkgs provided do:
    nix-index #which pkg provides a lib use nix-locate -1 -w libssapi_krb5.so.2
    home-manager
######################################################################
    #basic basic bare minimum stuff
    nh # nix helper
    bash
    curl
    openssl
    gitFull
    nano
    vim
    busybox
# run `busybox --list` before you add a command it's probably already installed
    SumContext.packages.${pkgs.system}.sumtree
    dutree
######################################################################
    #C development
    tinycc
    bmake
    byacc
    libffi.dev
    gcc
    binutils
    coreutils
    cmake
    gnumake
######################################################################
    jq
    python3
    poetry
    pipx
    uv
    pyproject-nix
    pyproject-build-systems
    uv2nix
    vulkan-tools
    vulkan-headers
    vulkan-loader
######################################################################
    # other dev languages
    perl
######################################################################
    # fonts require in 2 places in conf.nix to appear in apps corectly
    locked.google-fonts #1gb of fonts
######################################################################
    # Mate Network utilities necessary for Bluetooth an WiFi
    networkmanager
    blueman
    bluez
    bluez-tools
######################################################################
    # basic computer software, internet an multimedia
    gnome-keyring
    seahorse
    nautilus
    gparted
    unstable.chromium
#     ollama-vulkan
    vlc
    firefox
    mate.caja
    kdePackages.konsole
    kdePackages.kate
    gedit
    file-roller
    qalculate-gtk #Calculator
    dconf-editor
    gnome-system-monitor
    gnome-tweaks
    #atom       #fancy-text editor
    #libsForQt5.qtstyleplugin-kvantum
    mate.mate-tweak
    mate.marco

#     jdk #openjdk to allow java -jar YourJarFileName.jar
#     oraclejdk #not supported
# ########################################################################
#     #gnome2.GConf
#     radeontop
# 
# #     clinfo # is provided in rocm clr
#     rocmPackages.clr
# 
# #    hip #error: 'hip' has been removed in favor of 'rocmPackages.clr'
# #    hipify-perl
# #    pypi2nix
# #    required for lmstudio
    appimage-run
# 
# ####################locked packages that shouldn't be a security issue

];


########################################################################

#https://discourse.nixos.org/t/configuration-to-get-rocm-running-on-lmstudio-via-egpu-amd-5700xt-gfx1010/58951
###
       systemd.packages = with pkgs; [ lact ];
      systemd.services.lactd.wantedBy = ["multi-user.target"];
#       hardware.amdgpu.amdvlk.enable = true;
      services.ollama.acceleration = true;
      hardware.amdgpu.opencl.enable = true;
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
      mesa                            # Mesa drivers for AMD GPUs
      rocmPackages.clr               # Common Language Runtime for ROCm
      rocmPackages.clr.icd           # ROCm ICD for OpenCL
      rocmPackages.rocblas           # ROCm BLAS library
      rocmPackages.rpp               # High-performance computer vision library
#       amdvlk                         # AMDVLK Vulkan drivers
      nvtopPackages.amd              # GPU utilization monitoring

        ];
      };

  # Configure /opt/rocm symlink for ROCm hardcoded paths
  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        clr
        clr.icd
        rocblas
        hipblas
        rpp
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

  environment.variables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    ROCM_PATH = "/opt/rocm";                   # Set ROCm path
  #  HIP_VISIBLE_DEVICES = "0";                 # Use only the eGPU (ID 1)
#    ROCM_VISIBLE_DEVICES = "0";                # Optional: ROCm equivalent for visibility
    LD_LIBRARY_PATH = "/opt/rocm/lib";         # Add ROCm libraries
#    HSA_OVERRIDE_GFX_VERSION = "10.3.0";       # Set GFX version override
  };

########################################################################
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Enable networking
  networking.networkmanager.enable = true;
  # Enable network manager applet
  programs.nm-applet.enable = true;
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  users.extraGroups.vboxusers.members = [ "owner" ];
  virtualisation.virtualbox.guest.dragAndDrop = true;
  # virtualbox  # Run VMs of other OS

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Keyring daemon at the system level
  services.gnome.gnome-keyring.enable = true;

  # Enable the MATE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.mate.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  #environment.variables.QT_QPA_PLATFORMTHEME = "gtk2";
  # Tell Qt5 to use qt5ct for platform theming
#  programs.Qt5 = { #requires #qt5.qtbase qt5.qttools qt5ct
#    enable = true;
#    platformTheme = "qt5ct";
#  };
#  programs.qt6.enable = true;
#  programs.qt6.platformTheme = "qt6ct";
#  gsettings set org.mate.Marco.general compositing-manager true
#services.xserver.desktopManager.gnome.sessionPath = [ pkgs.gnome3.mutter ];
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  fonts.packages = with pkgs; [
    locked.google-fonts
  ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.owner = {
    isNormalUser = true;
    description = "owner";
    extraGroups = [ "networkmanager" "wheel" "vboxusers" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  programs.bash.interactiveShellInit = ''
    # --fallback gives ability to build if not connected (e.g. adding wifi after arriving to new location)
    # (--offline builds without connecting at all)
    build () {
      nh -v os build ~/nix_config --fallback ;
    }
    update_and_build () {
      nh -v os build --update ~/nix_config --fallback ;
    }
    switch () {
      nh -v os switch ~/nix_config --fallback ; # uses hostname for flake.
    }
    update_and_switch () {
      nh -v os switch --update ~/nix_config --fallback ; # uses hostname for flake.
    }
    boot () { # switches on boot
      nh -v os boot ~/nix_config --fallback ;
    }
    update_and_boot () { # update & switch - uses hostname for flake.
      nh -v os boot --update ~/nix_config --fallback ;
    }
  '';

  programs.firefox.enable = false; # Install firefox #better to do this manually
#  programs.mate.mate-system-monitor.enable = false; # Install firefox #better to do this manually

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

    services.gnome.gcr-ssh-agent.enable = false;


  # List services that you want to enable:
  # programs.ssh.startAgent = true;
    programs.ssh = {
      #enable = true;
      startAgent = true;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

