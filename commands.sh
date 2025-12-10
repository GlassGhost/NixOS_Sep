# cd into this path:
cd /home/owner/NixOS_Sep
# rebuild System with:
sudo nixos-rebuild switch --flake .#nixos
# rebuild user packages with:
home-manager switch --flake .#owner


exit
#example output
######################################################################

# update your system with:
sudo nix-collect-garbage -d
sudo nix-channel --update

######################################################################

[owner@nixos:~/NixOS_Sep]$ sudo nixos-rebuild switch --flake .#nixos
building the system configuration...
stopping the following units: accounts-daemon.service, cpufreq.service, vboxnet0.service
NOT restarting the following changed units: systemd-fsck@dev-disk-by\x2duuid-FCC5\x2d487C.service
activating the configuration...
setting up /etc...
restarting systemd...
reloading user units for owner...
restarting sysinit-reactivation.target
reloading the following units: dbus.service
restarting the following units: polkit.service, systemd-udevd.service
starting the following units: accounts-daemon.service, cpufreq.service, vboxnet0.service
the following new units were started: sysinit-reactivation.target, systemd-tmpfiles-resetup.service
Done. The new configuration is /nix/store/yq68nkdj1kd6qi7m8h1yvxp8sh1a9j8j-nixos-system-nixos-25.05.20251010.7e297dd

###

[owner@nixos:~/NixOS_Sep]$ home-manager switch --flake .#owner
warning: download buffer is full; consider increasing the 'download-buffer-size' setting
Starting Home Manager activation
Activating checkFilesChanged
Activating checkLinkTargets
Activating writeBoundary
Creating new profile generation
Activating installPackages
installing 'home-manager-path'
building '/nix/store/lr47ganl6d46hgdfkllwlp6fbb4wi4mj-user-environment.drv'...
Activating linkGeneration
Creating home file links in /home/owner
Activating onFilesChange
Activating reloadSystemd


[owner@nixos:~/sync/sumtree]$ sudo nix-collect-garbage -d
deleting unused links...
note: currently hard linking saves -0.00 MiB
11393 store paths deleted, 29662.59 MiB freed
